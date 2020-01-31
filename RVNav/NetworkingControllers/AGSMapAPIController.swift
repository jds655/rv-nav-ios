//
//  AGSMapAPIController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS

enum MapAPIControllerError: Error {
    case errorGettingAvoidances(String)
    case noAvoidancesReturned
}

class AGSMapAPIController: NSObject, MapAPIControllerProtocol, AGSGeoViewTouchDelegate {
    
    // MARK: - Properties
    var delegate: ViewDelegateProtocol?
    internal var avoidanceController: AvoidanceControllerProtocol
    
    private let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)
    var geoCoder = AGSLocatorTask(url:URL(string: "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer")!)
    
    // MARK: -  Lifecycle
    required init(avoidanceController: AvoidanceControllerProtocol) {
        self.avoidanceController = avoidanceController
        super.init()
    }
    
    //Sets up credentials to access ArcGIS Routing with OURS
    func setupArcGISCredential() {
        let portal:AGSPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        let clientId = "taIMz5a6FZ8j6ZCs"
        let clientSecret = "42694cda208b4c95b7c07673ca877f92"
        portal.getAppIDToken(clientId: clientId, clientSecret: clientSecret) { (credential, error) in
            guard error == nil else {
                print("Could not get credential! \(error!.localizedDescription)")
                return
            }
            print("Got a credential: \(credential!)")
        }
    }
    
    // MARK: - Public Methods
    func search(with address: String, completion: @escaping ([AGSGeocodeResult]?) -> Void) {
        geoCoder.geocode(withSearchText: address) { (results, error) in
            if let error = error {
                NSLog("Error geocoding address to placemarks: \(error)")
                completion(nil)
                return
            }
            if let results  = results {
                completion(results)
                return
            }
        }
    }
    
    func fetchRoute(from route: RouteInfo, completion: @escaping (AGSRoute?, Error?) -> Void) {
        
        fetchBarriers(from: route) { (barriers, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            
            guard let barriers = barriers else {
                completion(nil, nil); #warning("fix error")
                return
            }
            
            self.routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
                guard error == nil else {
                    print("Error getting default parameters: \(error!.localizedDescription)")
                    completion(nil, nil); #warning("fix error")
                    return
                }
                let startCLCoordinate = CLLocationCoordinate2D(latitude: route.startLat, longitude: route.startLon)
                let endCLCoordinate = CLLocationCoordinate2D(latitude: route.endLat, longitude: route.endLon)
                let startPoint = AGSPoint(clLocationCoordinate2D: startCLCoordinate)
                let endPoint = AGSPoint(clLocationCoordinate2D: endCLCoordinate)
                
                guard let params = defaultParameters, let self = self else { return }
                
                params.setStops([AGSStop(point: startPoint), AGSStop(point: endPoint)])
                params.setPolygonBarriers(barriers)
                params.returnDirections = true
                
                self.routeTask.solveRoute(with: params){ (result, error) in
                    guard error == nil else {
                        print("Error solving route: \(error!.localizedDescription)")
                        completion(nil, error)
                        return
                    }
                    if let firstRoute = result?.routes.first {
                        completion (firstRoute,nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchBarriers(from route: RouteInfo, completion: @escaping ([AGSPolygonBarrier]?, MapAPIControllerError?) -> Void) {
        avoidanceController.getAvoidances(with: route) { (avoidances, error) in
            var barriers: [AGSPolygonBarrier] = []
            let const = 0.0001
            
            if let error = error {
                NSLog("Error fetching avoidances:\(error)")
                completion(nil, .errorGettingAvoidances("Error fetching avoidances:\(error)"))
                return
            }
            guard let avoidances = avoidances else {
                completion(nil,.noAvoidancesReturned)
                return
            }
            for avoid in avoidances {
                let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude + const)))
                let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude - const)))
                let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude - const)))
                let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude + const)))
                let gon = AGSPolygon(points: [point, point1, point2, point3])
                let barrier = AGSPolygonBarrier(polygon: gon)
                
                barriers.append(barrier)
            }
            completion(barriers, nil)
        }
    }
}
//private func convert(toLongAndLat xPoint: Double, andYPoint yPoint: Double) ->
//    CLLocation {
//        let originShift: Double = 2 * .pi * 6378137 / 2.0
//        let lon: Double = (xPoint / originShift) * 180.0
//        var lat: Double = (yPoint / originShift) * 180.0
//        lat = 180 / .pi * (2 * atan(exp(lat * .pi / 180.0)) - .pi / 2.0)
//        return CLLocation(latitude: lat, longitude: lon)
//}

// Used to display barrier points retrieved from the DS backend.
//private func plotAvoidance() {
//    #warning("change this from singlton to controller")
//    guard let vehicleInfo = RVSettings.shared.selectedVehicle,
//        let height = vehicleInfo.height,
//        let startLon = start?.longitude,
//        let startLat = start?.latitude,
//        let endLon = end?.longitude,
//        let endLat = end?.latitude  else { return }
//
//    let routeInfo = RouteInfo(height: height, startLon: startLon, startLat: startLat, endLon: endLon, endLat: endLat)
//
//    avoidanceController.getAvoidances(with: routeInfo) { (avoidances, error) in
//        if let error = error {
//            NSLog("error fetching avoidances \(error)")
//        }
//        if let avoidances = avoidances {
//            print(avoidances.count)
//
//            DispatchQueue.main.async {
//                for avoid in avoidances {
//                    let coor = CLLocationCoordinate2D(latitude: avoid.latitude, longitude: avoid.longitude)
//                    let point = AGSPoint(clLocationCoordinate2D: coor)
//                    self.addMapMarker(location: point, style: .X, fillColor: .red, outlineColor: .red)
//                }
//            }
//        }
//    }
//}

// Used to call DS backend for getting barriers coordinates.  Each coordinate is turned into a AGSPolygonBarrier and appended to an array.  The array is then returned.
//private func createBarriers() -> [AGSPolygonBarrier]{
//    let const = 0.0001
//    var barriers: [AGSPolygonBarrier] = [] {
//        didSet {
//            self.findRoute(with: barriers)
//        }
//    }
//    let startCoor = convert(toLongAndLat: mapView.locationDisplay.mapLocation!.x, andYPoint: mapView.locationDisplay.mapLocation!.y)
//
//
//    #warning("change this from singlton to controller")
//    guard let vehicleInfo = RVSettings.shared.selectedVehicle, let height = vehicleInfo.height, let endLon = end?.longitude, let endLat = end?.latitude  else { return []}
//
//    let routeInfo = RouteInfo(height: height, startLon: startCoor.coordinate.longitude, startLat: startCoor.coordinate.latitude, endLon: endLon, endLat: endLat)
//
//    avoidanceController.getAvoidances(with: routeInfo) { (avoidances, error) in
//        if let error = error {
//            NSLog("error fetching avoidances \(error)")
//        }
//        if let avoidances = avoidances {
//            var tempBarriers: [AGSPolygonBarrier] = []
//
//            for avoid in avoidances {
//                let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude + const)))
//                let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude - const)))
//                let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude - const)))
//                let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude + const)))
//                let gon = AGSPolygon(points: [point, point1, point2, point3])
//                let barrier = AGSPolygonBarrier(polygon: gon)
//
//                tempBarriers.append(barrier)
//
//                // Used to print out the barriers for testing cxpurposes.
//
//                //                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .red, width: 8)
//                //                    let routeGraphic = AGSGraphic(geometry: gon, symbol: routeSymbol, attributes: nil)
//                //                    self.graphicsOverlay.graphics.add(routeGraphic)
//            }
//            barriers = tempBarriers
//            print("Barriers count: \(tempBarriers.count)")
//        }
//    }
//    return barriers
//}

// adds a mapmarker at a given location.
//private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
//    let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 8)
//    pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
//    let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
//    graphicsOverlay.graphics.add(markerGraphic)
//}
//
//// Allows users location to be used and displayed on the main mapView.
//private func setupLocationDisplay() {
//    mapView.locationDisplay.autoPanMode = .compassNavigation
//    mapView.locationDisplay.start { [unowned self] (error:Error?) -> Void in
//        if let error = error {
//            self.showAlert(withStatus: error.localizedDescription)
//        }
//    }
//}


// This function sets the default paramaters for finding a route between 2 locations.  Barrier points are used as a parameter.  The route is drawn to the screen.
//    func findRoute(with barriers: [AGSPolygonBarrier]) {
//
//        routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
//            guard error == nil else {
//                print("Error getting default parameters: \(error!.localizedDescription)")
//                return
//            }
//
//            guard let params = defaultParameters, let self = self, let start = self.mapView.locationDisplay.mapLocation, let end = self.end else { return }
//
//            params.setStops([AGSStop(point: start), AGSStop(point: end)])
//            params.setPolygonBarriers(barriers)
//
//            self.routeTask.solveRoute(with: params, completion: { (result, error) in
//                guard error == nil else {
//                    print("Error solving route: \(error!.localizedDescription)")
//                    return
//                }
//                #warning("Grok the routes returned, why not offer more to the user to choose from")
//                if let firstRoute = result?.routes.first, let routePolyline = firstRoute.routeGeometry {
//                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 8)
//                    let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
//                    self.graphicsOverlay.graphics.removeAllObjects()
//                    self.graphicsOverlay.graphics.add(routeGraphic)
//                    let totalDistance = Measurement(value: firstRoute.totalLength, unit: UnitLength.meters)
//                    let totalDuration = Measurement(value: firstRoute.travelTime, unit: UnitDuration.minutes)
//                    let formatter = MeasurementFormatter()
//                    formatter.numberFormatter.maximumFractionDigits = 2
//                    formatter.unitOptions = .naturalScale
//
//                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: nil, message: """
//                            Total distance: \(formatter.string(from: totalDistance))
//                            Travel time: \(formatter.string(from: totalDuration))
//                            """, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                        self.delegate?.present(alert, animated: true, completion: nil)
//                    }
//                }
//            })
//        }
//    }
