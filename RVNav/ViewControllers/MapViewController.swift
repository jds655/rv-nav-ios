//
//  MapViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/19/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import SwiftKeychainWrapper
import FirebaseAnalytics
//comment
//class MapViewController: UIViewController, MGLMapViewDelegate {
//
//    let networkController = NetworkController()
//    let retreivedVehicle = UserDefaults.standard.integer(forKey: "VehicleId")
//    @IBOutlet weak var navigateButton: UIButton!
//    var mapView: NavigationMapView!
//    var directionsRoute: Route!
//    var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(37.77440680146262, -122.43539772352648),
//                                                 CLLocationCoordinate2DMake(37.76556957793795, -122.42409811526268),
//                                                 CLLocationCoordinate2DMake(37.76557635453635, -121.234565447653453),
//                                                 CLLocationCoordinate2DMake(56.234234234232, -116.234234246345665)]
//
//    let disneylandCooridinate = CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        mapView = NavigationMapView(frame: view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(mapView)
//
//        mapView.delegate = self
//
//        mapView.showsUserLocation = true
//        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
//
//        Analytics.logEvent("app_opened", parameters: nil)
//
//        print("Your Vehicle ID is: \(retreivedVehicle)")
//
//
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if KeychainWrapper.standard.string(forKey: "accessToken") == nil {
//            performSegue(withIdentifier: "ShowLogin", sender: self)
//
//
//        }
//    }
//
//
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        return true
//    }
//
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        let navigationVC = NavigationViewController(for: directionsRoute!)
//        present(navigationVC, animated: true, completion: nil)
//    }
//
//    func drawRoute(route: Route) {
//        guard route.coordinateCount > 0 else { return }
//
//        for coordinate in coordinates {
//            print(coordinate)
//        }
//        let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))
//
//        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
//            source.shape = polyline
//        } else {
//            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
//
//            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
//
//
//            mapView.style?.addSource(source)
//            mapView.style?.addLayer(lineStyle)
//        }
//    }
//
//
//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowLogin" {
//            let destinationVC = segue.destination as! LoginViewController
//            destinationVC.networkController = networkController
//        }
//    }
//    @IBAction func logOutButtonTapped(_ sender: Any) {
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "accessToken")
//        performSegue(withIdentifier: "ShowLogin", sender: self)
//        print("Remove successful: \(removeSuccessful)")
//
//    }
//}
//



class MapViewController: UIViewController, MGLMapViewDelegate {
    var networkController = NetworkController()
    var mapView: NavigationMapView!
    var directionsRoute: Route?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = NavigationMapView(frame: view.bounds)

        view.addSubview(mapView)

        // Set the map view's delegate
        mapView.delegate = self

        // Allow the map to display the user's location
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)

        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        Analytics.logEvent("app_opened", parameters: nil)
        mapView.addGestureRecognizer(longPress)
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeychainWrapper.standard.string(forKey: "accessToken") == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)


        }
    }

    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }

        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)

        // Calculate the route from the user's location to the set destination
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }

    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {

        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")

        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)

        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }

    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)

        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)

            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)

            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }

    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ShowLogin" {
                    let destinationVC = segue.destination as! LoginViewController
                    destinationVC.networkController = networkController
                }
            }
            @IBAction func logOutButtonTapped(_ sender: Any) {
                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "accessToken")
                performSegue(withIdentifier: "ShowLogin", sender: self)
                print("Remove successful: \(removeSuccessful)")

            }
}
