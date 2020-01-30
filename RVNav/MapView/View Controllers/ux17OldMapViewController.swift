//
//  MapViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/19/19.
//  Copied bu Joshua Sharp on 01/13/2020
//  Notes: Migrated UI over to new ux17 Design

//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAnalytics
import ArcGIS

class ux17OldMapViewController: UIViewController, AGSGeoViewTouchDelegate {
    
    // MARK: - Properties
    private var modelController = ModelController(userController: UserController())
    private var directionsController: DirectionsControllerProtocol = DirectionsController(mapAPIController: AGSMapAPIController(avoidanceController: AvoidanceController()))
    private let graphicsOverlay = AGSGraphicsOverlay()
    private var start: AGSPoint?
    private var end: AGSPoint?
    private var avoidances: [Avoid] = []
    private var coordinates: [CLLocationCoordinate2D] = []
    private let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private var barriers: [AGSPolygonBarrier] = []
    
    
    #warning("Save and restore from userdefauls")
    private var mapType: AGSBasemapType = .navigationVector {
        didSet{
            guard let location = mapView.locationDisplay.location,
                let lat = location.position?.y,
                let lon = location.position?.x else { return }
            mapView.map = AGSMap(basemapType: mapType, latitude: lat, longitude: lon, levelOfDetail: 0)
        }
    }
    private let avoidanceController = AvoidanceController()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: AGSMapView!
    @IBOutlet weak var getRouteTestButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getRouteWithBarriers(from:)), name: .barriersAdded, object: nil)
        Analytics.logEvent("app_opened", parameters: nil)
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
        let startCoord = CLLocationCoordinate2D(latitude: 34.740070, longitude: -92.295000)
        let endCoord = CLLocationCoordinate2D(latitude: 34.741428, longitude: -92.294998)
        start = AGSPoint(clLocationCoordinate2D: startCoord)
        end = AGSPoint(clLocationCoordinate2D: endCoord)
        
        let vehicle = Vehicle(id: 2, name: "Big Jim", height: 13, weight: 5555.0, width: 10.0, length: 38.0, axelCount: 3, vehicleClass: "Class A", dualTires: true, trailer: nil)
        let routeInfo = RouteInfo(height: vehicle.height!, startLon: startCoord.longitude, startLat: startCoord.latitude, endLon: endCoord.longitude, endLat: endCoord.latitude)
        
        fetchBarriers(from: routeInfo)
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
    
    private func fetchBarriers(from route: RouteInfo) {
        avoidanceController.getAvoidances(with: route) { (avoidances, error) in
            let const = 0.0001
            
            if let error = error {
                NSLog("Error fetching avoidances:\(error)")
            }
            
            guard let avoidances = avoidances else { return }
            
            for avoid in avoidances {
                let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude + const)))
                let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude - const)))
                let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude - const)))
                let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude + const)))
                let gon = AGSPolygon(points: [point, point1, point2, point3])
                let barrier = AGSPolygonBarrier(polygon: gon)
                
                self.barriers.append(barrier)
                
                // Used to print out the barriers for testing purposes.
                let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .red, width: 8)
                let routeGraphic = AGSGraphic(geometry: gon, symbol: routeSymbol, attributes: nil)
                self.graphicsOverlay.graphics.add(routeGraphic)
            }
            NotificationCenter.default.post(name: .barriersAdded, object: nil)
        }
    }
    
    @objc private func getRouteWithBarriers(from notification: NSNotification) {
        #warning("Remove test data")
        let startCoord = CLLocationCoordinate2D(latitude: 34.740070, longitude: -92.295000)
        let endCoord = CLLocationCoordinate2D(latitude: 34.741428, longitude: -92.294998)
        start = AGSPoint(clLocationCoordinate2D: startCoord)
        end = AGSPoint(clLocationCoordinate2D: endCoord)
        
        let vehicle = Vehicle(id: 2, name: "Big Jim", height: 13, weight: 5555.0, width: 10.0, length: 38.0, axelCount: 3, vehicleClass: "Class A", dualTires: true, trailer: nil)
        let routeInfo = RouteInfo(height: vehicle.height!, startLon: startCoord.longitude, startLat: startCoord.latitude, endLon: endCoord.longitude, endLat: endCoord.latitude)
        
        fetchRoute(from: routeInfo, with: barriers)
    }
    
    private func fetchRoute(from route: RouteInfo, with barriers: [AGSPolygonBarrier]) {
        routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
            guard error == nil else {
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }
            let startCLCoordinate = CLLocationCoordinate2D(latitude: route.startLat, longitude: route.startLon)
            let endCLCoordinate = CLLocationCoordinate2D(latitude: route.endLat, longitude: route.endLon)
            let startPoint = AGSPoint(clLocationCoordinate2D: startCLCoordinate)
            let endPoint = AGSPoint(clLocationCoordinate2D: endCLCoordinate)

            guard let params = defaultParameters, let self = self else { return }

            params.setStops([AGSStop(point: startPoint), AGSStop(point: endPoint)])
            params.setPolygonBarriers(self.barriers)
            params.returnDirections = true

            self.routeTask.solveRoute(with: params, completion: { (result, error) in
                guard error == nil else {
                    print("Error solving route: \(error!.localizedDescription)")
                    return
                }
                
                if let firstRoute = result?.routes.first, let routePolyline = firstRoute.routeGeometry {
                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 4)
                    let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
                    self.graphicsOverlay.graphics.add(routeGraphic)
                }
                guard let start = self.start, let end = self.end  else { return }
                
                DispatchQueue.main.async {
                    guard let firstRoute = result?.routes.first else { return }
                    self.addMapMarker(location: startPoint, style: .diamond, fillColor: .green, outlineColor: .black)
                    self.addMapMarker(location: endPoint, style: .X, fillColor: .red, outlineColor: .red)
                    self.mapView.setViewpointGeometry(firstRoute.routeGeometry!, padding: 100) { (_) in
                    }
                }
            })
        }
    }
    
    // adds a mapmarker at a given location.
    private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
        let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 12)
        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
        let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
        graphicsOverlay.graphics.add(markerGraphic)
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
extension ux17OldMapViewController: MenuDelegateProtocol {
    func performSelector(selector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        performSelector(onMainThread: selector, with: arg, waitUntilDone: wait)
    }
    
    func performSegue(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}

extension ux17OldMapViewController: AGSLocationChangeHandlerDelegate {
}
