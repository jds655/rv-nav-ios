//
//  DirectionController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class DirectionsController: DirectionsControllerProtocol {
    var destinationAddress: AddressProtocol?
    internal var mapAPIController: MapAPIControllerProtocol
    
    required init(mapAPIController: MapAPIControllerProtocol, avoidanceController: AvoidanceControllerProtocol = AvoidanceController()) {
        self.mapAPIController = mapAPIController(mapAPIController: mapAPIController, avoidanceController: avoidanceController)
    }
    
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void) {
        mapAPIController.search(with: address) { (addresses) in
            completion(addresses)
        }
        
    }
}
