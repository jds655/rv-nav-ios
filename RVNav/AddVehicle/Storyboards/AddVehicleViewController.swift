//
//  AddVehicleViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/13/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class AddVehicleViewController: ShiftableViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var vehicleNameTextField: UITextField!
    @IBOutlet weak var heightFeetTextField: UITextField!
    @IBOutlet weak var heightInchesTextField: UITextField!
    @IBOutlet weak var widthFeetTextField: UITextField!
    @IBOutlet weak var widthInchesTextField: UITextField!
    @IBOutlet weak var lengthFeetTextField: UITextField!
    @IBOutlet weak var lengthInchesTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var axelCountTextField: UITextField!
    @IBOutlet weak var duelWheelSwitch: UISwitch!
    @IBOutlet weak var rvTypeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        buttonUISetup()
    }
    
    private func buttonUISetup() {
        //cancel button
        cancelButton.layer.borderWidth = 0.4
        cancelButton.layer.borderColor = UIColor.babyBlue.cgColor
        cancelButton.layer.cornerRadius = 4
        //add button
        addButton.layer.borderWidth = 0.4
        addButton.layer.borderColor = UIColor.babyBlue.cgColor
        addButton.layer.cornerRadius = 4
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == rvTypeTextField {
            view.endEditing(true)
            performSegue(withIdentifier: "ShowRVTypesSegue", sender: self)
        }
    }
    
}

