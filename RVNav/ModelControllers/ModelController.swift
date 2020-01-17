//
//  ModelController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class ModelController {
    let userController: UserControllerProtocol
    let vehicleController: VehicleModelControlorProtocol


    init (userController: UserControllerProtocol = UserController(), vehicleController: VehicleModelControlorProtocol = VehicleModelController(networkController: FirebaseNetworkController())) {
        self.userController = userController
        self.vehicleController = vehicleController
    }
}
