//
//  CustomMenuArrow.swift
//  RVNav
//
//  Created by Jake Connerly on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import DropDown

class CustomDropDownTextField: UIControl {
    
    public  var delegate: CustomDropDownTextFieldDelegate?
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldHeight: CGFloat = 45.0
    
    private let heeboRegularFont = UIFont(name: "Heebo-Regular", size: 16)
    
    private var textFieldWasTapped: Bool = false
    
    private var textField: UITextField = UITextField()
    private var accessoryImageView: UIImageView = UIImageView()
    private var dividerLine: UIView = UIView()
    private var dropDownArrowContainerView: UIView = UIView()
    private var dropDownArrow: UIImageView = UIImageView()
    private var dropDownVehicles: DropDown = DropDown()
    private let coverButton: UIButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupTextField()
        setAssessoryImageView()
        setDropDownArrow()
        setupVehicleDropDownUI()
        setupVehicleDropDownCellConfiguration()
        setupCoverButtonUI()
        NotificationCenter.default.addObserver(self, selector: #selector(editingEnded), name: .outsideViewTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVehiclesDropDown(from:)), name: .vehiclesAdded, object: nil)
    }
    
    @objc func editingEnded() {
        textField.endEditing(true)
        dropDownArrow.rotateBack()
    }
    
    private func setupUI() {
        layer.cornerRadius = 4
    }
    
    private func setupTextField() {
        textField.font = heeboRegularFont
        textField.textColor = .black
        textField.isUserInteractionEnabled = false
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        // TextField Constraints
        let textFieldLeadingAnchor  = textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 45)
        let textFieldTopAnchor      = textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        let textFieldTrailingAnchor = textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -50)
        let textFieldBottomAnchor   = textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
        dividerLine.layer.cornerRadius = 4
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dividerLine)
        // Divider Line Contraints
        let dividerLineHeightAnchor = dividerLine.heightAnchor.constraint(equalToConstant: 30)
        let dividerLineWidthAnchor = dividerLine.widthAnchor.constraint(equalToConstant: 1.5)
        let dividerLineTopAnchor = dividerLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        let dividerLineTrailingAnchor = dividerLine.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -45)
        NSLayoutConstraint.activate([dividerLineHeightAnchor, dividerLineWidthAnchor, dividerLineTopAnchor, dividerLineTrailingAnchor])
    }
    
    private func setDropDownArrow() {
        //ContainerView
        dropDownArrowContainerView.layer.cornerRadius = 4
        dropDownArrowContainerView.translatesAutoresizingMaskIntoConstraints = false
        dropDownArrowContainerView.backgroundColor = .clear
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
    
    private func setupVehicleDropDownUI() {
        dropDownVehicles.anchorView = self
        dropDownVehicles.dismissMode = .automatic
        DropDown.appearance().setupCornerRadius(4)
        DropDown.appearance().textFont = heeboRegularFont ?? UIFont.systemFont(ofSize: 16)
        dropDownVehicles.direction = .bottom
        dropDownVehicles.bottomOffset = CGPoint(x: 0, y: textFieldHeight)
    }
    
    private func setupCoverButtonUI() {
        coverButton.backgroundColor = .clear
        coverButton.translatesAutoresizingMaskIntoConstraints = false
        coverButton.layer.cornerRadius = 4
        addSubview(coverButton)
        // Cover Button Contraints
        let coverButtonLeadingAnchor  = coverButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0)
        let coverButtonTopAnchor      = coverButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        let coverButtonTrailingAnchor = coverButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0)
        let coverButtonBottomAnchor   = coverButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([coverButtonLeadingAnchor, coverButtonTopAnchor, coverButtonTrailingAnchor, coverButtonBottomAnchor])
        //Cover Button target
        coverButton.addTarget(self, action: #selector(dropDown(sender:)), for: .touchUpInside)
    }
    
    @objc private func dropDown(sender: UIButton) {
        dropDownVehicles.show()
        dropDownArrow.rotateUp()
        dropDownVehicles.selectionAction = { (index: Int, item: String) in
            self.textField.text = item
            self.dropDownArrow.rotateBack()
        }
    }
    
    private func setupVehicleDropDownCellConfiguration() {
        dropDownVehicles.dataSource = [""]
        dropDownVehicles.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
        dropDownVehicles.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CustomDropDownCell else { return }
            cell.delegate = self
            if index == 0 {
                cell.optionLabel.isHidden = true
            } else {
                cell.addVehicleButton.isHidden = true
            }
        }
    }
    
    @objc private func reloadVehiclesDropDown(from notification: NSNotification) {
        guard let vehicles = notification.userInfo?["vehicles"] as? [Vehicle] else { return }
        for vehicle in vehicles {
            if let vehicleName = vehicle.name {
                dropDownVehicles.dataSource.append(vehicleName)
            }
        }
        dropDownVehicles.reloadAllComponents()
    }
}

extension CustomDropDownTextField: CustomDropDownCellDelegate {
    func performSegue(segueIdentifier: String) {
        dropDownVehicles.hide()
        delegate?.performSegue(segueID: segueIdentifier)
    }
}

extension UIView {
    func rotateUp() {
        func rotateUpward() { transform = CGAffineTransform(rotationAngle: CGFloat.pi) }
        UIView.animate(withDuration: 0.3, animations: rotateUpward)
    }
    
    func rotateBack() {
        func rotateBackToOriginalPosition() { transform = .identity }
        UIView.animate(withDuration: 0.3, animations: rotateBackToOriginalPosition)
    }
}

extension CustomDropDownTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropDownArrow.rotateUp()
        dropDownVehicles.show()
        dropDownVehicles.selectionAction = { (index: Int, item: String) in
            self.textField.text = item
            textField.endEditing(true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropDownArrow.rotateBack()
    }
}
