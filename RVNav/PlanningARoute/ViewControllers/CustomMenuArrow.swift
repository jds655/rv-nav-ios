//
//  CustomMenuArrow.swift
//  RVNav
//
//  Created by Jake Connerly on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit


class CustomMenuArrow: UIControl {
    


}

extension UIView {
    func rotate() {
        func rotateUp() { transform = CGAffineTransform(rotationAngle: CGFloat.pi) }
        func rotateBack() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { rotateUp() },
                       completion: { _ in UIView.animate(withDuration: 0.3) { rotateBack() }})
    }
}
