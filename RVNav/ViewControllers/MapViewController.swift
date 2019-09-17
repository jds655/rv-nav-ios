//
//  MapViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/19/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxCoreNavigation
import MapboxDirections
import SwiftKeychainWrapper
import FirebaseAnalytics
import MapboxGeocoder
import Contacts
import Floaty
import ArcGIS


class MapViewController: UIViewController, AGSGeoViewTouchDelegate {
    
    var networkController = NetworkController()
    let directionsController = DirectionsController()
    let graphicsOverlay = AGSGraphicsOverlay()
    var start: AGSPoint?
    var end: AGSPoint?
    let geocoder = Geocoder.shared
    var avoidances: [Avoid] = []
    var coordinates: [CLLocationCoordinate2D] = []
    let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)
    @IBOutlet weak var mapView: AGSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("app_opened", parameters: nil)
        setupMap()
        setupFloaty()
        setupLocationDisplay()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if directionsController.destinationAddress != nil {
            let destination = directionsController.destinationAddress!.location!.coordinate
            end = AGSPoint(clLocationCoordinate2D: destination)
            createBarriers()
        }
    }


    func convert(toLongAndLat xPoint: Double, andYPoint yPoint: Double) ->
        CLLocation {
            let originShift: Double = 2 * .pi * 6378137 / 2.0
            let lon: Double = (xPoint / originShift) * 180.0
            var lat: Double = (yPoint / originShift) * 180.0
            lat = 180 / .pi * (2 * atan(exp(lat * .pi / 180.0)) - .pi / 2.0)
            return CLLocation(latitude: lat, longitude: lon)
    }


    func plotAvoidance() {
        let startCoor = convert(toLongAndLat: mapView.locationDisplay.mapLocation!.x, andYPoint: mapView.locationDisplay.mapLocation!.y)

        guard let vehicleInfo = Settings.shared.selectedVehicle, let height = vehicleInfo.height, let endLon = directionsController.destinationAddress?.location?.coordinate.longitude, let endLat = directionsController.destinationAddress?.location?.coordinate.latitude  else { return }

        let routeInfo = RouteInfo(height: height, startLon: startCoor.coordinate.longitude, startLat: startCoor.coordinate.latitude, endLon: endLon, endLat: endLat)

        networkController.getAvoidances(with: routeInfo) { (avoidances, error) in
            if let error = error {
                NSLog("error fetching avoidances \(error)")
            }
            if let avoidances = avoidances {
                self.avoidances = avoidances
                print(avoidances.count)

                DispatchQueue.main.async {

                for avoid in avoidances {
                    let coor = CLLocationCoordinate2D(latitude: avoid.latitude, longitude: avoid.longitude)
                    let point = AGSPoint(clLocationCoordinate2D: coor)
                    self.addMapMarker(location: point, style: .X, fillColor: .red, outlineColor: .red)

                }
                }
            }
        }

    }

// This is for the Plus button floating on the map
    func setupFloaty() {
        let carIcon = UIImage(named: "car")
        let floaty = Floaty()
        floaty.addItem("Directions", icon: carIcon) { (item) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowAddressSearch", sender: self)
            }
        }

        floaty.addItem("Avoid", icon: carIcon) { (item) in
            DispatchQueue.main.async {
                self.plotAvoidance()
            }
        }

        floaty.paddingY = 42
        floaty.buttonColor = .black
        floaty.plusColor = .green
        self.view.addSubview(floaty)
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeychainWrapper.standard.string(forKey: "accessToken") == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)


        }
    }

    private func setupMap() {
        mapView.map = AGSMap(basemapType: .streetsNightVector, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 18)
        mapView.touchDelegate = self
        mapView.graphicsOverlays.add(graphicsOverlay)
    }

    private func setupLocationDisplay() {
        mapView.locationDisplay.autoPanMode = .compassNavigation

        mapView.locationDisplay.start { [weak self] (error:Error?) -> Void in
            if let error = error {
                self?.showAlert(withStatus: error.localizedDescription)
            }
        }

    }

    private func showAlert(withStatus: String) {
        let alertController = UIAlertController(title: "Alert", message:
            withStatus, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }


    func createBarriers() -> [AGSPolygonBarrier]{

        let const = 0.0001

        var barriers: [AGSPolygonBarrier] = [] {
            didSet {
                self.findRoute(with: barriers)
            }
        }
        let startCoor = convert(toLongAndLat: mapView.locationDisplay.mapLocation!.x, andYPoint: mapView.locationDisplay.mapLocation!.y)

        guard let vehicleInfo = Settings.shared.selectedVehicle, let height = vehicleInfo.height, let endLon = directionsController.destinationAddress?.location?.coordinate.longitude, let endLat = directionsController.destinationAddress?.location?.coordinate.latitude  else { return []}

        let routeInfo = RouteInfo(height: height, startLon: startCoor.coordinate.longitude, startLat: startCoor.coordinate.latitude, endLon: endLon, endLat: endLat)

        networkController.getAvoidances(with: routeInfo) { (avoidances, error) in
            if let error = error {
                NSLog("error fetching avoidances \(error)")

            }
            if let avoidances = avoidances {
                var tempBarriers: [AGSPolygonBarrier] = []



                for avoid in avoidances {
                    let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude + const)))
                    let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude + const), longitude: (avoid.longitude - const)))
                    let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude - const)))
                    let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (avoid.latitude - const), longitude: (avoid.longitude + const)))
                    let gon = AGSPolygon(points: [point, point1, point2, point3])
                    let barrier = AGSPolygonBarrier(polygon: gon)
                    tempBarriers.append(barrier)
//                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .red, width: 8)
//                    let routeGraphic = AGSGraphic(geometry: gon, symbol: routeSymbol, attributes: nil)
//                    self.graphicsOverlay.graphics.add(routeGraphic)
                    }


                barriers = tempBarriers
                print(tempBarriers.count)

            }

        }



        return barriers
        
    }

    func findRoute(with barriers: [AGSPolygonBarrier]) {

        var customConfig = URLSessionConfiguration.default
        customConfig.timeoutIntervalForRequest = 120
        
        routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
            guard error == nil else {
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }

            guard let params = defaultParameters, let self = self, let start = self.mapView.locationDisplay.mapLocation, let end = self.end else { return }
            
            
            
            params.setStops([AGSStop(point: start), AGSStop(point: end)])

            params.setPolygonBarriers(barriers)

            self.routeTask.solveRoute(with: params, completion: { (result, error) in
                guard error == nil else {
                    print("Error solving route: \(error!.localizedDescription)")
                    return
                }

                if let firstRoute = result?.routes.first, let routePolyline = firstRoute.routeGeometry {
                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .yellow, width: 8)
                    let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
//                    self.graphicsOverlay.graphics.removeAllObjects()
                    self.graphicsOverlay.graphics.add(routeGraphic)
                    let totalDistance = Measurement(value: firstRoute.totalLength, unit: UnitLength.meters)
                    let totalDuration = Measurement(value: firstRoute.travelTime, unit: UnitDuration.minutes)
                    let formatter = MeasurementFormatter()
                    formatter.numberFormatter.maximumFractionDigits = 2
                    formatter.unitOptions = .naturalScale

                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: nil, message: """
                            Total distance: \(formatter.string(from: totalDistance))
                            Travel time: \(formatter.string(from: totalDuration))
                            """, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }

//    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
//        if start == nil {
//            // Start is not set, set it to a tapped location.
//            setStartMarker(location: mapPoint)
//
//
//
//        } else if end == nil {
//            // End is not set, set it to the tapped location then find the route.
//            setEndMarker(location: mapPoint)
//
//        } else {
//            // Both locations are set; re-set the start to the tapped location.
//            setStartMarker(location: mapPoint)
//        }
//    }
//
    private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
        let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 8)
        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
        let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
        graphicsOverlay.graphics.add(markerGraphic)
    }
//
//    private func setStartMarker(location: AGSPoint) {
//        graphicsOverlay.graphics.removeAllObjects()
//        let startMarkerColor = UIColor(red:0.886, green:0.467, blue:0.157, alpha:1.000)
//        addMapMarker(location: location, style: .diamond, fillColor: startMarkerColor, outlineColor: .blue)
//        start = location
//        end = nil
//    }
//
//    private func setEndMarker(location: AGSPoint) {
//        let endMarkerColor = UIColor(red:0.157, green:0.467, blue:0.886, alpha:1.000)
//        addMapMarker(location: location, style: .square, fillColor: endMarkerColor, outlineColor: .red)
//        end = location
//        findRoute()
//    }




    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLogin" {
            let destinationVC = segue.destination as! LoginViewController
            destinationVC.networkController = networkController
        }
        if segue.identifier == "ShowAddressSearch" {
            let destinationVC = segue.destination as! DirectionsSearchTableViewController
            destinationVC.directionsController = directionsController
        }
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "accessToken")
            performSegue(withIdentifier: "ShowLogin", sender: self)
            print("Remove successful: \(removeSuccessful)")
        }
}
