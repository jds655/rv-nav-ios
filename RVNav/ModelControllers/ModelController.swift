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
    lazy var vehicleController: VehicleModelControllerProtocol? = {
        guard let userID = userController.currentUserID else {
            return nil
        }
        return VehicleModelController(userID: userID, networkController: FirebaseNetworkController())
        }() as VehicleModelControllerProtocol?

    init (userController: UserControllerProtocol = UserController()) {
        self.userController = userController
    }
    
//    func vehicleController()-> VehicleModelControllerProtocol? {
//        guard let userID = userController.currentUserID else {
//            return nil
//        }
//        return VehicleModelController(userID: userID, networkController: FirebaseNetworkController())
//    }
}
