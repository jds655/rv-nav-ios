// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import ArcGIS

class ViewController: UIViewController, AGSGeoViewTouchDelegate {

    @IBOutlet weak var mapView: AGSMapView!



    let graphicsOverlay = AGSGraphicsOverlay()
    var start: AGSPoint?
    var end: AGSPoint?
    let routeTask = AGSRouteTask(url: URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!)

    private func setupMap() {


        mapView.map = AGSMap(basemapType: .navigationVector, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 18)

        mapView.touchDelegate = self

        mapView.graphicsOverlays.add(graphicsOverlay)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    private func findRoute() {
        routeTask.defaultRouteParameters { [weak self] (defaultParameters, error) in
            guard error == nil else {
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }

            guard let params = defaultParameters, let self = self, let start = self.start, let end = self.end else { return }
            let coordinate = CLLocationCoordinate2D(latitude: 40.616280, longitude: -74.026192)
            let lat = 40.616280
            let lon = -74.026192
            let const = 0.0001
            let point = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat + const), longitude: (lon + const)))
            let point1 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat + const), longitude: (lon - const)))
            let point2 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat - const), longitude: (lon - const)))
            let point3 = AGSPoint(clLocationCoordinate2D: CLLocationCoordinate2D(latitude: (lat - const), longitude: (lon + const)))
            let gon = AGSPolygon(points: [point, point1, point2, point3])
            let barrier = AGSPolygonBarrier(polygon: gon)
            params.setStops([AGSStop(point: start), AGSStop(point: end)])

            params.setPolygonBarriers([barrier])

            self.routeTask.solveRoute(with: params, completion: { (result, error) in
                guard error == nil else {
                    print("Error solving route: \(error!.localizedDescription)")
                    return
                }

                if let firstRoute = result?.routes.first, let routePolyline = firstRoute.routeGeometry {
                    let routeSymbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 4)
                    let routeGraphic = AGSGraphic(geometry: routePolyline, symbol: routeSymbol, attributes: nil)
                    self.graphicsOverlay.graphics.add(routeGraphic)
                    print(firstRoute.routeGeometry?.parts[0])
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
                }
            })
        }
    }

    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        if start == nil {
            // Start is not set, set it to a tapped location.
            setStartMarker(location: mapPoint)
            print(mapPoint)
        } else if end == nil {
            // End is not set, set it to the tapped location then find the route.
            setEndMarker(location: mapPoint)
            print(mapPoint)
        } else {
            // Both locations are set; re-set the start to the tapped location.
            setStartMarker(location: mapPoint)
        }
    }

    private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
        let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 8)
        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
        let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
        graphicsOverlay.graphics.add(markerGraphic)
    }

    private func setStartMarker(location: AGSPoint) {
        graphicsOverlay.graphics.removeAllObjects()
        let startMarkerColor = UIColor(red:0.886, green:0.467, blue:0.157, alpha:1.000)
        addMapMarker(location: location, style: .diamond, fillColor: startMarkerColor, outlineColor: .blue)
        start = location
        end = nil
    }

    private func setEndMarker(location: AGSPoint) {
        let endMarkerColor = UIColor(red:0.157, green:0.467, blue:0.886, alpha:1.000)
        addMapMarker(location: location, style: .square, fillColor: endMarkerColor, outlineColor: .red)
        end = location
        findRoute()
    }
}
