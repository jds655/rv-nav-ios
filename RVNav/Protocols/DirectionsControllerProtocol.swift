//
//  DirectionsControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

protocol DirectionsControllerProtocol {
    var destinationAddress: AddressProtocol? {get set}
    var mapAPIController: MapAPIControllerProtocol {get set}
    
    init(mapAPIController: MapAPIControllerProtocol, avoidanceController: AvoidanceControllerProtocol)
    
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void)
}
