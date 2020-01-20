//
//  VehicleModelControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol VehicleModelControllerProtocol {
    var networkController: NetworkControllerProtocol {get set}
    var vehicles: [Vehicle] {get set}
    
    init(userID: Int, networkController: NetworkControllerProtocol)
    
    func createVehicle(with vehicle: Vehicle, completion: @escaping (Error?) -> Void)
    
    func editVehicle(with vehicle: Vehicle, vehicleID: Int, completion: @escaping (Error?) -> Void)
    
    func deleteVehicle(vehicleID: Int, completion: @escaping (Error?) -> Void)
    
    func getVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void)
}
