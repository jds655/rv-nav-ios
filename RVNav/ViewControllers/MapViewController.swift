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
import MapboxGeocoder
import Contacts


class MapViewController: UIViewController, MGLMapViewDelegate, UISearchBarDelegate {
    var networkController = NetworkController()
    var mapView: NavigationMapView!
    var directionsRoute: Route?
    let geocoder = Geocoder.shared
  
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerMapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView = NavigationMapView(frame: containerMapView.bounds)

        containerMapView.addSubview(mapView)

        // Set the map view's delegate
        mapView.delegate = self

        // Allow the map to display the user's location
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)

        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        Analytics.logEvent("app_opened", parameters: nil)
        mapView.addGestureRecognizer(longPress)
        
       searchBar.delegate = self
        
//      search()
    }

    func search() {
      
        
        let options = ForwardGeocodeOptions(query: "106 Chippendale Ter")
        options.allowedScopes = [.address, .pointOfInterest]
        
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
        
            print(placemark.name)
            // 200 Queen St
            if let placemarkQualifiedName = placemark.qualifiedName {
            print(placemarkQualifiedName)
            // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada
            }
            let coordinate = placemark.location!.coordinate
            print("\(coordinate.latitude), \(coordinate.longitude)")
            // 45.270093, -66.050985
            
            #if !os(tvOS)
            let formatter = CNPostalAddressFormatter()
            print(formatter.string(from: placemark.postalAddress!))
            // 200 Queen St
            // Saint John New Brunswick E2L 2X1
            // Canada
            #endif
        
            self.calculateRoute(from: self.mapView.userLocation!.coordinate, to: coordinate, completion: { (route, error) in
                if error != nil {
                    print("Error calculating route")
                }
            })
        }
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
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
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
    func calculateRoute(from originCoor: CLLocationCoordinate2D,
                        to destinationCoor: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {

        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")

        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)

        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
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
//                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "accessToken")
//                performSegue(withIdentifier: "ShowLogin", sender: self)
//                print("Remove successful: \(removeSuccessful)")
                search()

            }
}
