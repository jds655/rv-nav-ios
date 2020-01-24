//
//  PlanARouteViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit


class PlanARouteViewController: UIViewController {
    
    // MARK: - Properties
    var vehicleController: VehicleModelControllerProtocol?
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectedVehicle: CustomDropDownTextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        vehicleController?.delegate = self
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - Private Methods
    
    private func updateViews () {
        
    }
    
    @IBAction func viewWasTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .outsideViewTapped, object: nil)
    }
    
}
// MARK: - Extensions
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

