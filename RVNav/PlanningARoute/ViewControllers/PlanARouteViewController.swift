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
    var route: Route?{
        didSet{
            
        }
    }
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
        updateViews()
        vehicleController?.delegate = self
        selectedVehicle.delegate = self
        startLocation.delegate = self
        endLocation.delegate = self
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
            let vc = segue.destination as? RouteResultsViewController
            //let routeInfo = RouteInfo(height: <#T##Float#>, startLon: <#T##Double#>, startLat: <#T##Double#>, endLon: <#T##Double#>, endLat: <#T##Double#>)
            vc?.mapAPIController = self.mapAPIController
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
