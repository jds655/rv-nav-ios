//
//  MapAPIController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//
#warning("Another attempt to offload map/routing from viewcontroller, needs work or scrapped")

import Foundation
import ArcGIS

class MapAPIController : MapAPIControllerProtocol, AGSGeoViewTouchDelegate {
    
    // MARK: - Properties
    var delegate: ViewDelegateProtocol?
    var avoidanceController: AvoidanceControllerProtocol
    
    private var avoidances: [Avoid] = []
    private var coordinates: [CLLocationCoordinate2D] = []
   
    
    
    // MARK: - View Lifecycle
    required init(avoidanceController: AvoidanceControllerProtocol) {
        self.avoidanceController = avoidanceController
        setupMap()
    }
    
    // MARK: - Public Methods
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void) {
        
    }
    
    // This function sets the default paramaters for finding a route between 2 locations.  Barrier points are used as a parameter.  The route is drawn to the screen.
    func findRoute(with barriers: [AGSPolygonBarrier]) {
        
    }
    
    // MARK: - Private Methods
    
    
    
    // Shows alert if there was an error displaying location.
    private func showAlert(withStatus: String) {
        let alertController = UIAlertController(title: "Alert", message:
            withStatus, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.delegate?.present(alertController, animated: true, completion: nil)
    }
    
  
}
