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
    var userID: Int
    var vehicles: [Vehicle] = []
    
    init (userID: Int, networkController: NetworkControllerProtocol = WebRESTAPINetworkController()) {
        self.networkController = networkController
        self.userID = userID
        networkController.getVehicles(for: userID) { (vehicles, error) in
            if let error = error {
                print ("VehicleModelController: Failed to fetch vehicles: \(error)")
            }
            if let vehicles = vehicles {
                self.vehicles = vehicles
            }
        }
    }
    
    func createVehicle(with vehicle: Vehicle, userID: Int, completion: @escaping (Error?) -> Void) {
        networkController.createVehicle(with: vehicle, userID: userID, completion: completion)
    }
    
    func editVehicle(with vehicle: Vehicle, vehicleID: Int, userID: Int, completion: @escaping (Error?) -> Void) {
        networkController.editVehicle(with: vehicle, vehicleID: vehicleID, userID: userID, completion: completion)
        
    }
    
    func deleteVehicle(vehicleID: Int, userID: Int, completion: @escaping (Error?) -> Void) {
        networkController.deleteVehicle(vehicleID: vehicleID, userID: userID, completion: completion)
    }
    
    func getVehicles(userID: Int, completion: @escaping ([Vehicle]?, Error?) -> Void) {
        networkController.getVehicles(for: userID, completion: completion)
    }
}
