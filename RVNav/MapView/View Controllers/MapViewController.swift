//
//  MapViewController.swift
//  RVNav
//
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAnalytics
import ArcGIS

class MapViewController: UIViewController, AGSGeoViewTouchDelegate {
    
    // MARK: - Properties
    private var modelController = ModelController(userController: UserController())
    private var directionsController: DirectionsControllerProtocol =
        DirectionsController(mapAPIController: AGSMapAPIController(avoidanceController:
            AvoidanceController(avoidanceProvider:
                LambdaDSAvoidanceProvider())))
    private let graphicsOverlay = AGSGraphicsOverlay()
    private let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)
    
    private var mapType: AGSBasemapType = .navigationVector {
        didSet{
            guard let location = mapView.locationDisplay.location,
                let lat = location.position?.y,
                let lon = location.position?.x else { return }
            if let route = directionsController.mapAPIController.selectedRoute,
                let routeGeometry = route.routeGeometry {
                self.mapView.setViewpointGeometry(routeGeometry, padding: 100, completion: nil)
            }
            mapView.map = AGSMap(basemapType: mapType, latitude: lat, longitude: lon, levelOfDetail: 18)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: AGSMapView!
    @IBOutlet weak var getRouteTestButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("app_opened", parameters: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mapRoute(notification:)), name: .routeNeedsMapped, object: nil)
        setupMap()
    }
    
    deinit {
        mapView.locationDisplay.stop()
        mapView = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.isFirstLaunch() {
            performSegue(withIdentifier: "LandingPageSegue", sender: self)
        } else if KeychainWrapper.standard.string(forKey: "accessToken") == nil && !UserDefaults.isFirstLaunch() {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            let destinationVC = segue.destination as! SignInViewController
            destinationVC.userController = modelController.userController
        }
        if segue.identifier == "LandingPageSegue" {
            let destinationVC = segue.destination as! LandingPageViewController
            destinationVC.userController = modelController.userController
        }
        if segue.identifier == "HamburgerMenu" {
            let destinationVC = segue.destination as! CustomSideMenuNavigationController
            destinationVC.modelController = modelController
            destinationVC.mapAPIController = directionsController.mapAPIController
            destinationVC.menuDelegate = self
        }
    }
    
    // MARK: - IBActions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        modelController.userController.logout {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToMapView(segue:UIStoryboardSegue) { }
    
    @IBAction func getRouteTestButtonTapped(_ sender: UIButton) {
        #warning("Remove test button and its data")
        var start: AGSPoint?
        var end: AGSPoint?
        let startCoord = CLLocationCoordinate2D(latitude: 34.740070, longitude: -92.295000)
        let endCoord = CLLocationCoordinate2D(latitude: 34.741428, longitude: -92.294998)
        start = AGSPoint(clLocationCoordinate2D: startCoord)
        end = AGSPoint(clLocationCoordinate2D: endCoord)
        
        let vehicle = Vehicle(id: 2, name: "Big Jim", height: 13, weight: 5555.0, width: 10.0, length: 38.0, axelCount: 3, vehicleClass: "Class A", dualTires: true, trailer: nil)
        let routeInfo = RouteInfo(height: vehicle.height!, startLon: startCoord.longitude, startLat: startCoord.latitude, endLon: endCoord.longitude, endLat: endCoord.latitude)
        
        directionsController.mapAPIController.fetchRoute(from: routeInfo) { (route, error) in
            if let error = error {
                NSLog("MapViewController: Error fetching route: \(error)")
                return
            }
            guard let route = route else {
                NSLog("MapViewController: No route returned.")
                return
            }
            //line below is for testing
            //self.printRoute(with: route)
            guard let start = start, let end = end  else { return }
            DispatchQueue.main.async {
                if let routePolyline = route.routeGeometry {
                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 4)
                    let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
                    self.graphicsOverlay.graphics.add(routeGraphic)
                }
                self.addMapMarker(location: start, style: .diamond, fillColor: .green, outlineColor: .black)
                self.addMapMarker(location: end, style: .X, fillColor: .red, outlineColor: .red)
                if let routeGeometry = route.routeGeometry {
                    self.mapView.setViewpointGeometry(routeGeometry, padding: 100, completion: nil)
                }
            }
        }
    }
    
    @objc public func mapRoute(notification: NSNotification) {
        guard let route = directionsController.mapAPIController.selectedRoute else { return }
        DispatchQueue.main.async {
            if let routePolyline = route.routeGeometry {
                let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 4)
                let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
                self.graphicsOverlay.graphics.add(routeGraphic)
            }
            guard let start = route.stops.first?.geometry,
                let end = route.stops.last?.geometry else { return }
            self.addMapMarker(location: start, style: .diamond, fillColor: .green, outlineColor: .black)
            self.addMapMarker(location: end, style: .X, fillColor: .red, outlineColor: .red)
            self.mapView.setViewpointGeometry(route.routeGeometry!, padding: 100, completion: nil)
        }
        ARSLineProgress.hide()
    }
    
    // MARK: - Private Methods
    
    // Creates a new instance of AGSMap and sets it to the mapView.
    private func setupMap() {
        mapView.locationDisplay.autoPanMode = .recenter
        mapView.locationDisplay.start {error in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("ERROR: Error starting AGSLocationDisplay: \(error)")
                    self.mapView.map = AGSMap(basemapType: self.mapType, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 0)
                } else {
                    if let location = self.mapView.locationDisplay.location,
                        let lat = location.position?.y ,
                        let lon = location.position?.x {
                        self.mapView.map = AGSMap(basemapType: self.mapType, latitude: lat, longitude: lon, levelOfDetail: 0)
                    } else {
                        self.mapView.map = AGSMap(basemapType: self.mapType, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 0)
                    }
                }
            }
        }
        mapView.touchDelegate = self
        mapView.graphicsOverlays.add(graphicsOverlay)
    }
    
    // adds a mapmarker at a given location.
    private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
        let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 12)
        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
        let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
        graphicsOverlay.graphics.add(markerGraphic)
    }
    
    func printRoute(with route: AGSRoute) {
        print ("Total Time: \(String(route.totalTime))")
        print ("Total Length: \(String(route.totalLength))")
        print ("***Stops***")
        for stop in route.stops.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.sequence < rhs.sequence
        }) {
            print("Stop \(stop.sequence): name: \(stop.name) for route \(stop.routeName)  ")
        }
        print ("  ***Maneuvers***")
        for maneuver in route.directionManeuvers {
            print ("    Maneuver text: \(maneuver.directionText)")
            print ("    Maneuver lenght: \(maneuver.length)")
            print ("    Maneuver text: \(maneuver.directionText)")
            print ("      Messages:")
            for message in maneuver.maneuverMessages {
                print ("           message: \(message.text)  type: \(String(describing: message.type))")
            }
            print ("    Maneuver type: \(String(describing: maneuver.maneuverType))")
        }
        
    }
    
    // MARK: - Selectors
    @objc func map_street () {
        self.mapType = .navigationVector
    }
    
    @objc func map_sat () {
        self.mapType = .imageryWithLabelsVector
    }
    
    @objc func map_ter () {
        self.mapType = .terrainWithLabelsVector
    }
    
    @objc private func logout() {
        logOutButtonTapped(self)
    }
}


// MARK: - Extensions
extension MapViewController: MenuDelegateProtocol {
    func performSelector(selector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        performSelector(onMainThread: selector, with: arg, waitUntilDone: wait)
    }
    
    func performSegue(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}

extension MapViewController: AGSLocationChangeHandlerDelegate {
}
