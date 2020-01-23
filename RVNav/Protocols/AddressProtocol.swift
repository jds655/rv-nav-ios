//
//  AddressProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import CoreLocation

protocol AddressProtocol {
//    var identifier:String {get set}
//    var name:String {get set}
//    var address:String {get set}
//    var qualifiedName:String {get set}
//    var superiorPlacemarks:String {get set}
//    var centerCoordinate: String {get set}
//    var code: String {get set}
    var location: CLLocation? {get set}
}
