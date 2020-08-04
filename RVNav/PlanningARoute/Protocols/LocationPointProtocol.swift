//
//  LocationPointProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/24/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS
import CoreLocation

protocol LocationPointProtocol {
    var latitude: Double {get}
    var longitude: Double {get}
}

extension AGSPoint: LocationPointProtocol {
    var latitude: Double {
        get {
            return self.y
        }
    }
    var longitude: Double {
        get {
            return self.x
        }
    }
}

extension CLLocationCoordinate2D: LocationPointProtocol {
    
}


