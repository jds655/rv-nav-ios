//
//  VehicleModelController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/15/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class VehicleModelController {
    var networkController: NetworkControllerProtocol = NetworkController()
    var vehicles: [Vehicle] = []
    
    init () {
        networkController.getVehicles { (vehicles, error) in
            if let error = error {
                print ("VehicleModelController: Failed to fetch vehicles: \(error)")
            }
            if let vehicles = vehicles {
                self.vehicles = vehicles
            }
        }
    }
}
