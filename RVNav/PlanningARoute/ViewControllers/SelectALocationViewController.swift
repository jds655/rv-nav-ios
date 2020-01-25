//
//  SelectALocationViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/24/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS
import CoreLocation

class SelectALocationViewController: UIViewController {
    
    // MARK: - Properties
    var delegate: SelectALocationDelegate?
    var mapAPIController: MapAPIControllerProtocol?
    private let graphicsOverlay = AGSGraphicsOverlay()
    private var searchResults: [AddressProtocol]? {
        didSet{
            tableView.reloadData()
        }
    }
    private var selectedLocation: AddressProtocol?{
        didSet{
            centerMapOnLocation(selectedLocation!)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var searchView: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var mapView: AGSMapView!
    @IBOutlet weak private var selectButton: UIButton!
    
    // MARK: - View Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchView.delegate = self
        setupMap()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - IBActions
    @IBAction private func closeTapped(_ sender: Any) {
        self.selectedLocation = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func selectTapped(_ sender: UIButton) {
        guard let selectedLocation = self.selectedLocation else { return }
        delegate?.locationSelected(location: selectedLocation)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func setupMap() {
        mapView.touchDelegate = self
        mapView.viewpointChangedHandler = {
            //Keep pin in center
        }
        mapView.locationDisplay.start {error in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("ERROR: Error starting AGSLocationDisplay: \(error)")
                    self.mapView.map = AGSMap(basemapType: .navigationVector, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 18)
                } else {
                    if let location = self.mapView.locationDisplay.location,
                        let lat = location.position?.y ,
                        let lon = location.position?.x {
                        self.mapView.map = AGSMap(basemapType: .navigationVector, latitude: lat, longitude: lon, levelOfDetail: 18)
                    } else {
                        self.mapView.map = AGSMap(basemapType: .navigationVector, latitude: 40.615518, longitude: -74.026005, levelOfDetail: 18)
                    }
                }
            }
        }
        mapView.touchDelegate = self
        mapView.graphicsOverlays.add(graphicsOverlay)
    }
    
    private func centerMapOnLocation(_ location: AddressProtocol) {
        guard let coordinate = location.location?.coordinate else { return }
        let point = coordinate as LocationPointProtocol
        mapView.setViewpointCenter(point as! AGSPoint) { (finished) in
            self.graphicsOverlay.graphics.removeAllObjects()
            if finished {
                self.graphicsOverlay.graphics.removeAllObjects()
                self.addMapMarker(location: location as! AGSPoint, style: .diamond, fillColor: .babyBlue, outlineColor: .black)
            }
        }
    }
    
    private func addMapMarker(location: AGSPoint, style: AGSSimpleMarkerSymbolStyle, fillColor: UIColor, outlineColor: UIColor) {
        let pointSymbol = AGSSimpleMarkerSymbol(style: style, color: fillColor, size: 8)
        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: outlineColor, width: 2)
        let markerGraphic = AGSGraphic(geometry: location, symbol: pointSymbol, attributes: nil)
        graphicsOverlay.graphics.add(markerGraphic)
    }
}

// MARK: - Extensions

// MARK: - UISearchBarDelegate Extension

extension SelectALocationViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_: UISearchBar) {
        guard let searchString = searchView.text else { return }
        mapAPIController?.search(with: searchString, completion: { (addresses) in
            self.searchResults = addresses
        })
    }
}

// MARK: - UITableView Extensions
extension SelectALocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultCell", for: indexPath)
        cell.textLabel?.text = searchResults?[indexPath.row].identifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = searchResults?[indexPath.row] else { return }
        selectedLocation = location
    }
}

// MARK: - MapTouchDelegate Extension
extension SelectALocationViewController: AGSGeoViewTouchDelegate {
    func geoView(_ geoView: AGSGeoView, didEndLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        let locationPoint = mapPoint
        mapAPIController?.geoCoder.reverseGeocodeLocation(CLLocation(latitude: locationPoint.y, longitude: locationPoint.x), completionHandler: { (placemarks, error) in
            if let error = error {
                NSLog("SelectALocationViewController - Error reverse geocoding touched point. Error: \(error)")
                return
            }
            guard let placemark = placemarks?.first as? AddressProtocol else { return }
            self.selectedLocation =  placemark
        })
    }
}
