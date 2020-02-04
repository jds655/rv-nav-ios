//
//  CustomDropDownTextField.swift
//  RVNav
//
//  Created by Jake Connerly on 1/21/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import DropDown

//@IBDesignable
class CustomDropDownTextField: UIControl {
    
    private var _cornerRadius: CGFloat = 4
    public  var delegate: CustomDropDownTextFieldDelegate?
    private var _standardMargin: CGFloat = 8.0
    private var _textFieldHeight: CGFloat = 45.0
    private var _font: UIFont //= heeboRegularFont
    private var _textColor: UIColor = .black
    private var _isRotated = false
    
    
    private let heeboRegularFont = UIFont(name: "Heebo-Regular", size: 16)
    private var label: UILabel = UILabel()
    private var accessoryImageView: UIImageView = UIImageView()
    private var dividerLine: UIView = UIView()
    private var dropDownArrowContainerView: UIView = UIView()
    private var dropDownArrow: UIImageView = UIImageView()
    private var dropDownVehicles: DropDown = DropDown()
    private let coverButton: UIButton = UIButton()
    public var text: String? {
        get {
            return label.text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        _font = heeboRegularFont!
        super.init(coder: aDecoder)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVehiclesDropDown(from:)), name: .vehiclesAdded, object: nil)
    }
    
    @objc func editingEnded() {
        label.endEditing(true)
        dropDownArrow.rotateBack()
        self._isRotated = false
    }
    
    private func setupUI() {
        layer.cornerRadius = _cornerRadius
        setupLabel()
        setAssessoryImageView()
        setDropDownArrow()
        setupVehicleDropDownUI()
        setupVehicleDropDownCellConfiguration()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropDown(sender:)))
        isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        setNeedsDisplay()
    }
    
    private func setupLabel() {
        label.font = _font
        label.textColor = .black
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        // Label Constraints
        let labelLeadingAnchor  = label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 45)
        let labelTopAnchor      = label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        let labelTrailingAnchor = label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -50)
        let labelBottomAnchor   = label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([labelLeadingAnchor, labelTopAnchor, labelTrailingAnchor, labelBottomAnchor])
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
        dividerLine.layer.cornerRadius = _cornerRadius
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
        dropDownArrowContainerView.layer.cornerRadius = _cornerRadius
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
        DropDown.appearance().setupCornerRadius(_cornerRadius)
        DropDown.appearance().textFont = heeboRegularFont ?? UIFont.systemFont(ofSize: 16)
        dropDownVehicles.direction = .bottom
        dropDownVehicles.bottomOffset = CGPoint(x: 0, y: _textFieldHeight)
        dropDownVehicles.cancelAction = {
            self.dropDownArrow.rotateBack()
            self._isRotated = false
        }
    }
        
    @objc private func dropDown(sender: UIButton) {
        dropDownVehicles.show()
        if !_isRotated {
            dropDownArrow.rotateUp()
            self._isRotated = true
        }
        dropDownVehicles.selectionAction = { (index: Int, item: String) in
            self.label.text = item
            self.dropDownArrow.rotateBack()
            self._isRotated = false
        }
    }
    
    private func setupVehicleDropDownCellConfiguration() {
        // This documentation can be found in DropDown Cocoapod
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

// MARK: - Extensions
extension CustomDropDownTextField: CustomDropDownCellDelegate {
    func performSegue(segueIdentifier: String) {
        dropDownVehicles.hide()
        delegate?.performSegue(segueID: segueIdentifier)
    }
}

extension UIView {
    // Rotating animation for menu item arrow
    func rotateUp() {
        func rotateUpward() { transform = CGAffineTransform(rotationAngle: CGFloat.pi) }
        UIView.animate(withDuration: 0.3, animations: rotateUpward)
    }
    
    func rotateBack() {
        func rotateBackToOriginalPosition() { transform = .identity }
        UIView.animate(withDuration: 0.3, animations: rotateBackToOriginalPosition)
    }
}

//Expose properties to IB
extension CustomDropDownTextField {
    @IBInspectable public var cornerRadius: CGFloat  {
        get {
            return _cornerRadius
        }
        set (newValue) {
            _cornerRadius = newValue
            setupUI()
        }
    }
    
    @IBInspectable public var height: CGFloat {
        get {
            return _textFieldHeight
        }
        set {
            _textFieldHeight = newValue
        }
    }
    
    @IBInspectable public var font: UIFont {
        get {
            return _font
        }
        set {
            _font = newValue
        }
    }
    
    @IBInspectable public var standardMargin: CGFloat {
        get {
            return _standardMargin
        }
        set {
            _standardMargin = newValue
        }
    }
    
    @IBInspectable public var textColor: UIColor {
        get {
            return _textColor
        }
        set {
            _textColor = newValue
        }
    }
}
