//
//  MapAPIProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS
import CoreLocation

protocol MapAPIControllerProtocol {
    var delegate: ViewDelegateProtocol? {get set}
    var geoCoder: CLGeocoder {get set}
    var mapView: AGSMapView {get set}
    var avoidanceController : AvoidanceControllerProtocol {get set}
    
    init (avoidanceController: AvoidanceControllerProtocol)
    
    func search(with address: String, completion: @escaping ([AddressProtocol]?) -> Void)
    
    func findRoute(with barriers: [AGSPolygonBarrier])
}
