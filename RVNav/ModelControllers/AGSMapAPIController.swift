//
//  AGSMapAPIController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import CoreLocation

class AGSMapAPIController: MapAPIControllerProtocol {
    var destinationAddress: AddressProtocol?
    var avoidanceController: AvoidanceControllerProtocol
    var mapAPIController: MapAPIControllerProtocol
    
    required init(mapAPIController: MapAPIControllerProtocol, avoidanceController: AvoidanceControllerProtocol) {
        self.avoidanceController = avoidanceController
        self.mapAPIController = mapAPIController
    }
    
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void) {
        
    }
    
    
}
