//
//  PlanARouteViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS

class PlanARouteViewController: UIViewController {
    
    // MARK: - Properties
    var vehicleController: VehicleModelControllerProtocol?
    var mapAPIController: MapAPIControllerProtocol?
    var sender: SelectALocationDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectedVehicle: CustomDropDownTextField!
    @IBOutlet weak var startLocation: SelectLocationTextField!
    @IBOutlet weak var endLocation: SelectLocationTextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        updateViews()
        vehicleController?.delegate = self
        selectedVehicle.delegate = self
        startLocation.delegate = self
        endLocation.delegate = self
        selectedVehicle.becomeFirstResponder()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddVehicleSegue":
            let vc = segue.destination as? AddVehicleViewController
            vc?.vehicleController = self.vehicleController
        case "SelectALocation":
            let vc = segue.destination as? SelectALocationViewController
            vc?.mapAPIController = self.mapAPIController
            vc?.delegate = self.sender
        case "RouteResults":
            guard let vc = segue.destination as? RouteResultsViewController,
                let mapAPIController = mapAPIController,
                let name = selectedVehicle.text,
                let height = vehicleController?.getVehicleHeight(with: name),
                let startName = startLocation.label,
                let startLon = startLocation.location?.displayLocation?.x,
                let startLat = startLocation.location?.displayLocation?.y,
                let endName = endLocation.label,
                let endLon = endLocation.location?.displayLocation?.x,
                let endLat = endLocation.location?.displayLocation?.y else { return }
            let routeInfo = RouteInfo(height: height, startName: startName, startLon: startLon, startLat: startLat, endName: endName, endLon: endLon, endLat: endLat)
            vc.mapAPIController = mapAPIController
            vc.routeInfo = routeInfo
        default:
            break
        }
    }
    
    // MARK: - IBActions
    @IBAction func openSelectLocation(_ sender: SelectLocationTextField) {
        openSelectALocation(target: sender)
    }
    
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
    }
    
    // MARK: - Private Methods
    private func updateViews () {
    }
}

// MARK: - Extensions
extension PlanARouteViewController: CustomDropDownTextFieldDelegate {
    func performSegue(segueID: String) {
        self.performSegue(withIdentifier: segueID, sender: self)
    }
}

// MARK: - Extensions
extension PlanARouteViewController: VehicleModelDataDelegate {
    func didStartFetchingData() {
    }
    
    func didEndFetchingData(error: VehicleModelControllerError?) {
    }
    
    func dataDidChange() {
        guard let vehicleController = vehicleController else { return }
        let vehicles = vehicleController.vehicles
        NotificationCenter.default.post(name: .vehiclesAdded, object: self, userInfo: ["vehicles": vehicles])
    }
}

extension PlanARouteViewController: SelectALocationDelegate {
    func locationSelected(location: AGSGeocodeResult) {
        //should not be needed here
    }
    
    func openSelectALocation(target: SelectALocationDelegate) {
        self.sender = target
        performSegue(segueID: "SelectALocation")
    }
}
