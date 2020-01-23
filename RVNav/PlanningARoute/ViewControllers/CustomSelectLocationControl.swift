//
//  CustomSelectLocationControl.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/22/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

@objc enum CustomSelectLocationType: Int {
    case search = 0
    case map = 1
}

@IBDesignable
class CustomSelectLocationControl: UIControl {
    private let pointImage = UIImage(named: "greyLocation")
    private let searchImage = UIImage(named: "graySearch")
    private let controlMinHeight: CGFloat = 40
    
    private let topView = UIView()
    private let bottomView = UIView()
    private let stackView = UIStackView()
    private let textField = UITextField()
    private let uiImageView = UIImageView()
    private let tableView = UITableView()
    @IBInspectable public var type: CustomSelectLocationType = .map {
        didSet {
            setupSubViews()
        }
    }
    private var bottomHidden: Bool = false {
        didSet {
            setupSubViews()
        }
    }
    private let font = UIFont(name: "Heebo-Regular", size: 16.0)
    
    // Programmatic initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    // Storyboard initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tableView.delegate = self
        tableView.dataSource = self
        setupSubViews()
    }
    
    private func setupSubViews() {
        self.backgroundColor = .black
        //Add controlls to topView
            //Setup uiImageView
            topView.addSubview(uiImageView)
            uiImageView.translatesAutoresizingMaskIntoConstraints = false
            uiImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 5).isActive = true
            uiImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 5).isActive = true
            uiImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
            uiImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            //Set left image
            switch type {
            case .map:
                self.uiImageView.image = pointImage
            case .search:
                self.uiImageView.image = searchImage
            }
            //Setup textField
            textField.font = font
            textField.placeholder = "Choose a location"
            textField.textColor = .textColor
            textField.tintColor = .babyBlue
            topView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.leadingAnchor.constraint(equalTo: uiImageView.trailingAnchor, constant: 8).isActive = true
            textField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8 ).isActive = true
            textField.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
            textField.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 8).isActive = true
        //Add controlls to bottomView
        bottomView.isHidden = bottomHidden
        bottomView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        
        self.stackView.addSubview(topView)
        //topView constraints
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.heightAnchor.constraint(equalToConstant: controlMinHeight).isActive = true
        topView.leadingAnchor.constraint(equalTo: topView.superview!.leadingAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: topView.superview!.topAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: topView.superview!.trailingAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: topView.superview!.bottomAnchor).isActive = true
        self.stackView.addSubview(bottomView)
        //bottomView constraints
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: bottomView.superview!.leadingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: bottomView.superview!.topAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: bottomView.superview!.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomView.superview!.bottomAnchor).isActive = true
        //Add stackView to superView
        self.addSubview(stackView)
        //stackView constraints
        stackView.backgroundColor = .black
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //self.setNeedsDisplay()
    }
}

extension CustomSelectLocationControl: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
