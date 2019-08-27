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
class MapViewController: UIViewController, MGLMapViewDelegate {

    let networkController = NetworkController()
    @IBOutlet weak var navigateButton: UIButton!
    var mapView: NavigationMapView!
    var directionsRoute: Route!
    var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(37.77440680146262, -122.43539772352648),
                                                 CLLocationCoordinate2DMake(37.76556957793795, -122.42409811526268),
                                                 CLLocationCoordinate2DMake(37.76557635453635, -121.234565447653453),
                                                 CLLocationCoordinate2DMake(56.234234234232, -116.234234246345665)]

    let disneylandCooridinate = CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190)

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        mapView.delegate = self

        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)

        Analytics.logEvent("app_opened", parameters: nil)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeychainWrapper.standard.string(forKey: "accessToken") == nil {
            performSegue(withIdentifier: "ShowLogin", sender: self)
        }
    }


    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationVC = NavigationViewController(for: directionsRoute!)
        present(navigationVC, animated: true, completion: nil)
    }

    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }

        for coordinate in coordinates {
            print(coordinate)
        }
        let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))

        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)

            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)


            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
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



