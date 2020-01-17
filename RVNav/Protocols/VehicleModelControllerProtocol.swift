//
//  VehicleModelControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol VehicleModelControlorProtocol {
    func createVehicle(with vehicle: Vehicle, completion: @escaping (Error?) -> Void)
    
    func editVehicle(with vehicle: Vehicle, id: Int, completion: @escaping (Error?) -> Void)
    
    func deleteVehicle(id: Int, completion: @escaping (Error?) -> Void)
    
    func getVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void)
}
