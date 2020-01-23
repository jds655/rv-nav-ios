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
    
    private let heeboRegularFont = UIFont(name: "Heebo-Regular", size: 16)
    
    private var textFieldWasTapped: Bool = false
    
    private var textField: UITextField = UITextField()
    private var accessoryImageView: UIImageView = UIImageView()
    private var dividerLine: UIView = UIView()
    private var dropDownArrowContainerView: UIView = UIView()
    private var dropDownArrow: UIImageView = UIImageView()
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupTextField()
        setAssessoryImageView()
        setDropDownArrow()
    }
    
    private func setupUI() {
        layer.cornerRadius = 4
    }
    
    private func setupTextField() {
        textField.font = heeboRegularFont
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.isUserInteractionEnabled = false
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        // TextField Constraints
        let textFieldLeadingAnchor  = textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0)
        let textFieldTopAnchor      = textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        let textFieldTrailingAnchor = textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0)
        let textFieldBottomAnchor = textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([textFieldLeadingAnchor, textFieldTopAnchor, textFieldTrailingAnchor, textFieldBottomAnchor])
        
        
    }
    
    private func setAssessoryImageView() {
        accessoryImageView.image = UIImage(named: "grayCar1x")
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accessoryImageView)
        
        // Accessory Image Constraints
        let imageTopAnchor = accessoryImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let imageLeadingAnchor = accessoryImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8)
        let imageHeightAnchor = accessoryImageView.heightAnchor.constraint(equalToConstant: 30)
        let imageWidthAnchor = accessoryImageView.widthAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([imageTopAnchor, imageLeadingAnchor, imageHeightAnchor, imageWidthAnchor])
        
        //Divider Line
        dividerLine.backgroundColor = .gray
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        let dividerLineHeightAnchor = dividerLine.heightAnchor.constraint(equalToConstant: 45)
        let dividerLineWidthAnchor = dividerLine.widthAnchor.constraint(equalToConstant: 4)
        let dividerLineTopAnchor = dividerLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4)
        let dividerLineTrailingAnchor = dividerLine.trailingAnchor.constraint(equalTo: dropDownArrowContainerView.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([dividerLineHeightAnchor, dividerLineWidthAnchor, dividerLineTopAnchor, dividerLineTrailingAnchor])
    }
    
    private func setDropDownArrow() {
        
        //ContainerView
        dropDownArrowContainerView.layer.cornerRadius = 4
        dropDownArrowContainerView.translatesAutoresizingMaskIntoConstraints = false
        dropDownArrowContainerView.backgroundColor = .green
        addSubview(dropDownArrowContainerView)
        //ContainerView Constraints
        let dropdownContainerTopAnchor = dropDownArrowContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        let dropdownContainerTrailingAnchor = dropDownArrowContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0)
        let dropdownContainerBottomAnchor = dropDownArrowContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        let containerWidth = dropDownArrowContainerView.widthAnchor.constraint(equalToConstant: 45)
        let containerHeight = dropDownArrowContainerView.heightAnchor.constraint(equalToConstant: 45)
        NSLayoutConstraint.activate([dropdownContainerTopAnchor, dropdownContainerBottomAnchor, dropdownContainerTrailingAnchor, containerWidth, containerHeight])
        
        //DropDownArrow
        dropDownArrow.image = UIImage(named: "grayDropDown")
        dropDownArrow.translatesAutoresizingMaskIntoConstraints = false
        dropDownArrowContainerView.addSubview(dropDownArrow)
        //DropDownArrow Contraints
        let arrowHeightAnchor = dropDownArrow.heightAnchor.constraint(equalToConstant: 30)
        let arrowWidthAnchor = dropDownArrow.widthAnchor.constraint(equalToConstant: 30)
        let arrowTopAnchor = dropDownArrow.topAnchor.constraint(equalTo: dropDownArrowContainerView.topAnchor, constant: 6)
        let arrowTrailingAnchor = dropDownArrow.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        NSLayoutConstraint.activate([arrowHeightAnchor, arrowWidthAnchor, arrowTopAnchor, arrowTrailingAnchor])
    }
    
    class DropDownArrow: UIControl {
        
    }
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
