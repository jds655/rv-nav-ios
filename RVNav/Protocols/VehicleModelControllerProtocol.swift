//
//  VehicleModelControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol VehicleModelControlorProtocol {
    var networkController: NetworkControllerProtocol {get set}
    var vehicles: [Vehicle] {get set}
    var userID: Int {get set}
    
    func createVehicle(with vehicle: Vehicle, userID: Int, completion: @escaping (Error?) -> Void)
    
    func editVehicle(with vehicle: Vehicle, vehicleID: Int, userID: Int, completion: @escaping (Error?) -> Void)
    
    func deleteVehicle(vehicleID: Int, userID: Int, completion: @escaping (Error?) -> Void)
    
    func getVehicles(userID: Int, completion: @escaping ([Vehicle]?, Error?) -> Void)
}
