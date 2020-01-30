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
    private var directionsController: DirectionsControllerProtocol =
        DirectionsController(mapAPIController: AGSMapAPIController(avoidanceController:
            AvoidanceController(avoidanceProvider:
                LambdaDSAvoidanceProvider())))
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
    
    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: AGSMapView!
    @IBOutlet weak var getRouteTestButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("app_opened", parameters: nil)
        setupMap()
        directionsController.mapAPIController.setupArcGISCredential()  //move to init of mapAPI?
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
        
        directionsController.mapAPIController.fetchRoute(from: routeInfo) { (route, error) in
            if let error = error {
                NSLog("MapViewController: Error fetching route: \(error)")
                return
            }
            guard let route = route else {
                NSLog("MapViewController: No route returned.")
                return
            }
            guard let start = self.start, let end = self.end  else { return }
            DispatchQueue.main.async {
                #warning("Do we want to offer a list of routes to choose from?")
                self.addMapMarker(location: start, style: .diamond, fillColor: .green, outlineColor: .black)
                self.addMapMarker(location: end, style: .X, fillColor: .red, outlineColor: .red)
                self.mapView.setViewpointGeometry(route.routeGeometry!, padding: 100) { (_) in
                }
            }
        }
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
    
    @objc private func getRouteWithBarriers(from notification: NSNotification) {
        #warning("Remove test data")
        let startCoord = CLLocationCoordinate2D(latitude: 34.740070, longitude: -92.295000)
        let endCoord = CLLocationCoordinate2D(latitude: 34.741428, longitude: -92.294998)
        start = AGSPoint(clLocationCoordinate2D: startCoord)
        end = AGSPoint(clLocationCoordinate2D: endCoord)
        
        let vehicle = Vehicle(id: 2, name: "Big Jim", height: 13, weight: 5555.0, width: 10.0, length: 38.0, axelCount: 3, vehicleClass: "Class A", dualTires: true, trailer: nil)
        let routeInfo = RouteInfo(height: vehicle.height!, startLon: startCoord.longitude, startLat: startCoord.latitude, endLon: endCoord.longitude, endLat: endCoord.latitude)
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
