//
//  VehicleModelController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/15/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class VehicleModelController: VehicleModelControlorProtocol {
    var networkController: NetworkControllerProtocol
    var vehicles: [Vehicle] = []
    
    init (networkController: NetworkControllerProtocol = WebRESTAPINetworkController()) {
        self.networkController = networkController
        networkController.getVehicles { (vehicles, error) in
            if let error = error {
                print ("VehicleModelController: Failed to fetch vehicles: \(error)")
            }
            if let vehicles = vehicles {
                self.vehicles = vehicles
            }
        }
    }
    
    func createVehicle(with vehicle: Vehicle, completion: @escaping (Error?) -> Void) {
        networkController.createVehicle(with: vehicle, completion: completion)
    }
    
    func editVehicle(with vehicle: Vehicle, id: Int, completion: @escaping (Error?) -> Void) {
        networkController.editVehicle(with: vehicle, id: id, completion: completion)
        
    }
    
    func deleteVehicle(id: Int, completion: @escaping (Error?) -> Void) {
        networkController.deleteVehicle(id: id, completion: completion)
    }
    
    func getVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void) {
        networkController.getVehicles(completion: completion)
    }
}
