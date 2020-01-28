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
    var route: Route?
    var vehicleController: VehicleModelControllerProtocol?
    var mapAPIController: MapAPIControllerProtocol?
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectedVehicle: CustomDropDownTextField!
    @IBOutlet weak var startLocation: SelectLocationTextField!
    
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        vehicleController?.delegate = self
        selectedVehicle.delegate = self
        startLocation.delegate = self
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
            vc?.delegate = startLocation
        default:
            break
        }
    }
    
    // MARK: - IBActions
    @IBAction func openSelectLocation(_ sender: SelectLocationTextField) {
        openSelectALocation(target: sender)
    }
    
    // MARK: - Private Methods
    
    private func updateViews () {
        if let route = route {
            
        } else {
            
        }
    }
}

// MARK: - Extensions

extension PlanARouteViewController: CustomDropDownTextFieldDelegate {
    func performSegue(segueID: String) {
        self.performSegue(withIdentifier: segueID, sender: self)
    }
}

extension Notification.Name {
    static var outsideViewTapped = Notification.Name("OutsideViewTapped")
    static var vehiclesAdded = Notification.Name("VehiclesAdded")
}

extension PlanARouteViewController: VehicleModelDataDelegate {
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
//        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectALocationViewController") as? SelectALocationViewController else { return }
//        viewController.delegate = target
//        viewController.mapAPIController = self.mapAPIController
//        navigationController?.pushViewController(viewController, animated: true)
        performSegue(segueID: "SelectALocation")
    }
    
    
}
