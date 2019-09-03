//
//  Settings.swift
//  RVNav
//
//  Created by Ryan Murphy on 9/3/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import Foundation

class Settings {
    static let shared = Settings()
    private init() {}
    
    var selectedVehicle: Vehicle?
    var selectedVehicleIndex: Int = 0
    
}

extension String {
    static var selectedVehicleIndexKey = "selectedVehicleIndexKey"
    static var selectedVehicleKey = "selectedVehicleKey"
}
