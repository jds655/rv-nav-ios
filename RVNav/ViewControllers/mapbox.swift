//
//  mapbox.swift
//  RVNav
//
//  Created by Ryan Murphy on 9/9/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import Foundation
import Mapbox
import ArcGIS

class ViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!
    let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 28.668831, longitude: -81.20508),
            zoomLevel: 11,
            animated: false)
        view.addSubview(mapView)
         mapView.showsUserLocation = true
        mapView.delegate = self
        
        allCoordinates = coordinates
    }
    
    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        addPolyline(to: mapView.style!)
        animatePolyline()
    }
    
    func addPolyline(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.red)
        
        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 5, 18: 20])
        style.addLayer(layer)
        findRoute()
    }
    
    func animatePolyline() {
        currentIndex = 1
        
        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        // Update our MGLShapeSource with the current locations.
        updatePolylineWithCoordinates(coordinates: coordinates)
        
        currentIndex += 1
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
    
    private func findRoute() {
        routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
            guard error == nil else {
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }
            
            guard let params = defaultParameters, let self = self, let start = self.mapView.userLocation?.coordinate else { return }
             let end = CLLocationCoordinate2DMake(40.616280, -74.026192)
            let lat = 40.616280
            let lon = -74.026192
            let const = 0.0001
            let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat + const), longitude: (lon + const)))
            let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat + const), longitude: (lon - const)))
            let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat - const), longitude: (lon - const)))
            let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat - const), longitude: (lon + const)))
            let gon = AGSPolygon(points: [point, point1, point2, point3])
            let barrier = AGSPolygonBarrier(polygon: gon)
            
            
            
            let startCoordinate = AGSPoint(clLocationCoordinate2D: start)
            let endCoordinate = AGSPoint(clLocationCoordinate2D: end)
            
            params.setStops([AGSStop(point: startCoordinate), AGSStop(point: endCoordinate)])
            
            params.setPolygonBarriers([barrier])
            
            self.routeTask.solveRoute(with: params, completion: { (result, error) in
                guard error == nil else {
                    print("Error solving route: \(error!.localizedDescription)")
                    return
                }
                
                if let firstRoute = result?.routes.first{
                    let totalDistance = Measurement(value: firstRoute.totalLength, unit: UnitLength.meters)
                    let totalDuration = Measurement(value: firstRoute.travelTime, unit: UnitDuration.minutes)
                    
                    let formatter = MeasurementFormatter()
                    formatter.numberFormatter.maximumFractionDigits = 2
                    formatter.unitOptions = .naturalScale
                    
                    let alert = UIAlertController(title: nil, message: """
                        Total distance: \(formatter.string(from: totalDistance))
                        Travel time: \(formatter.string(from: totalDuration))
                        """, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    guard let geo = firstRoute.routeGeometry else { return }
                    let part = geo.parts[0]
                    
                    for index in 0..<geo.parts[0].pointCount{
                        let coordinate = CLLocationCoordinate2D(latitude: part.point(at: index).x, longitude: part.point(at: index).y)
                        self.coordinates.append(coordinate)
                    }
                   
                    
                }
            })
        }
    }
    
    var coordinates: [CLLocationCoordinate2D] = []
}
