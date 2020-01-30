//
//  MapAPIControllerProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS

protocol MapAPIControllerProtocol {
    var delegate: ViewDelegateProtocol? {get set}
    var geoCoder: AGSLocatorTask {get set}
    var mapView: AGSMapView {get set}
    var avoidanceController : AvoidanceControllerProtocol {get set}
    
    init (avoidanceController: AvoidanceControllerProtocol)
    
    func search(with address: String, completion: @escaping ([AGSGeocodeResult]?) -> Void)
    
    func findRoute(with barriers: [AGSPolygonBarrier])
}
