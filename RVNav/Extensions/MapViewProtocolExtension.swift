//
//  MapViewProtocolExtension.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS
import MapKit

extension AGSMapView: MapViewProtocol {
}

extension MKMapView: MapViewProtocol {
    var map: AGSMap {
        get {
            
        }
        set {
            
        }
    }
    
    var graphicsOverlays: AGSGraphicsOverlay {
        get {
            
        }
        set {
            
        }
    }
    
    var touchDelegate: AGSGeoViewTouchDelegate {
        get {
            
        }
        set {
            
        }
    }
    
    var locationDisplay: AGSLocationDisplay {
        get {
            
        }
        set {
            
        }
    }
    
    
}
