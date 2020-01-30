//
//  AvoidanceController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

class AvoidanceController: AvoidanceControllerProtocol {
    
    private var avoidanceProvider: AvoidanceProviderProtocol
    var avoidences: [Avoid]?
    
    required init(avoidanceProvider: AvoidanceProviderProtocol) {
        self.avoidanceProvider = avoidanceProvider
    }
    
    // Gets an array of avoidance coordinates from DS backend.
    func getAvoidances(with routeInfo: RouteInfo, completion: @escaping ([Avoid]?,Error?) -> Void) {
        avoidanceProvider.getAvoidances(with: routeInfo) { (avoidences, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let avoidences = avoidences {
                    self.avoidences = avoidences
                    completion(avoidences, nil)
                }
            }
        }
    }
        
}
