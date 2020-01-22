//
//  CustomMenuArrow.swift
//  RVNav
//
//  Created by Jake Connerly on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class CustomDropDownTextField: UIControl {
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    
    private let font = UIFont(name: "Heebo-Regular", size: 16)
    
    private var textFieldWasTapped: Bool = false
    
    private var textField: UITextField = UITextField()
    private var accessoryImageview: UIImageView = UIImageView()
    private var dividerLine: UIView = UIView()
    private var dropDownArrowContainerView: UIView = UIView()
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    func setupTextField() {
        textField.font = font
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        // TextField Constraints
        let textFieldLeadingAnchor  = textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: standardMargin)
        let textFieldTopAnchor      = textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin)
        let textFieldTrailingAnchor = textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([textFieldLeadingAnchor, textFieldTopAnchor, textFieldTrailingAnchor])
    }
}


class CustomMenuArrow: UIControl {
    
     private var dropDownArrowImageView: UIImageView = UIImageView()
    
    
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
extension CustomDropDownTextField: UITextFieldDelegate {
    
}
