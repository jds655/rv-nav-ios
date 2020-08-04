//
//  DirectionController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import UIKit
import ArcGIS

class DirectionsController: DirectionsControllerProtocol {
    
    var delegate: ViewDelegateProtocol?
    var destinationAddress: AGSPoint?
    var mapAPIController: MapAPIControllerProtocol
    
    required init(mapAPIController: MapAPIControllerProtocol) {
        self.mapAPIController = mapAPIController
        self.mapAPIController.delegate = self
    }
    
    func search(with address: String, completion: @escaping ([AGSGeocodeResult]?) -> Void) {
        mapAPIController.search(with: address) { (addresses) in
            completion(addresses)
        }
        
    }
}

extension DirectionsController: ViewDelegateProtocol {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        self.delegate?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    
}
