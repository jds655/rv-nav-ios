//
//  Double+toString.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 2/3/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
    func fromMetersToImperialString() -> String {
        var result: String = ""
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let feet = self * 3.280839895
        if feet <= 660 {
            numberFormatter.maximumFractionDigits = 0
            result =  "\(numberFormatter.string(from: NSNumber(value: feet))!) ft."
        } else {
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 3
            let miles:NSNumber = NSNumber(value: self * 0.0006213712)
            result = "\(numberFormatter.string(from: miles)!) mi."
        }
        return result
    }
}
