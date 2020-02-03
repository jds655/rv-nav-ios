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
    var selectedRoute: AGSRoute?{
        didSet{
            NotificationCenter.default.post(name: .routeNeedsMapped, object: self)
        }
    }
    
    // MARK: -  Lifecycle
    required init(avoidanceController: AvoidanceControllerProtocol) {
        self.avoidanceController = avoidanceController
        super.init()
        setupArcGISCredential()
    }
    
    //Sets up credentials to access ArcGIS Routing with OURS
    func setupArcGISCredential() {
        let portal:AGSPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        let clientId = "taIMz5a6FZ8j6ZCs"; #warning("Store credentials securly")
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
                
                params.clearStops()
                params.setStops([AGSStop(point: startPoint), AGSStop(point: endPoint)])
                params.clearPolygonBarriers()
                params.setPolygonBarriers(barriers)
                params.returnDirections = true
                params.returnStops = true
                params.directionsDistanceUnits = AGSUnitSystem(rawValue: 0)!
                
                self.routeTask.solveRoute(with: params){ (result, error) in
                    guard error == nil else {
                        print("Error solving route: \(error!.localizedDescription)")
                        completion(nil, error)
                        return
                    }
                    #warning("Do we want to offer a list of routes to choose from?")
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
