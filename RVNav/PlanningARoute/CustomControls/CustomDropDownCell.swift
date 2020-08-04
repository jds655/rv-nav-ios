//
//  AddVehicleCustomCellViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import DropDown

class CustomDropDownCell: DropDownCell {
    
    var delegate: CustomDropDownCellDelegate?
    
    @IBOutlet weak var addVehicleButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func addVehicleTapped(_ sender: UIButton) {
        delegate?.performSegue(segueIdentifier: "AddVehicleSegue")
    }
}
