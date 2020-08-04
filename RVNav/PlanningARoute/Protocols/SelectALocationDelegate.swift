//
//  SelectALocationDelegate.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/24/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS

protocol SelectALocationDelegate {
    func locationSelected(location: AGSGeocodeResult)
    func openSelectALocation(target: SelectALocationDelegate)
}
