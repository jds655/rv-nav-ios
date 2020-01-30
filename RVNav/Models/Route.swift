//
//  Route.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import ArcGIS

struct Route {
    var title: String
    var start: AGSPoint; #warning("How will we store this, what type?")
    var end: AGSPoint
    var vehicle: Vehicle
    var agsRoute: AGSRoute
}

struct RouteInfo: Codable {
    let height: Float
    let startLon: Double
    let startLat: Double
    let endLon: Double
    let endLat: Double
}
