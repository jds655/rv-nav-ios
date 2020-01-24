//
//  Route.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import CoreLocation

struct Route {
    #warning("Do we want to capture this?")
    //var title: String
    var start: CLLocation
    var end: CLLocation
    var vehicle: Vehicle
}

#warning("Create ModelController with FB/WebAPI NetworkControllers and/or local persistance")
