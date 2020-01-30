//
//  AvoidanceControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation


protocol AvoidanceControllerProtocol {
    var avoidences: [Avoid]? {get set}
    
    init(avoidanceProvider: AvoidanceProviderProtocol)
    
    func getAvoidances(with routeInfo: RouteInfo, completion: @escaping ([Avoid]?,Error?) -> Void)
}
