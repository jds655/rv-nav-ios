//
//  AGSDirectionManeuverType+UIImage.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/31/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS

extension AGSDirectionManeuverType {
    func image () -> UIImage {
        switch self {
        case .bearLeft:
            return UIImage(named: "slightleft")!
        case .bearRight:
            return UIImage(named: "slightright")!
        case .turnLeft, .turnLeftLeft, .sharpLeft:
            return UIImage(named: "corner-up-left")!
        case .turnRight, .turnRightRight, .sharpRight:
            return UIImage(named: "corner-up-right")!
        case .straight:
            return UIImage(named: "arrow-up")!
        default:
            return UIImage(named: "marker")!
        }
    }
}
