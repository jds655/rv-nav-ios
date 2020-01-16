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
    
    // MARK: - Properties
    
    var vehicle: Vehicle?
    var vehicles: [Vehicle]?
    var avoidance: [Avoid] = []
    var networkController: NetworkControllerProtocol = WebRESTAPINetworkController()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        buttonUISetup()
        dismissTapGestureRecogniser()
    }
    
    // MARK: - Private Methods
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func dismissTapGestureRecogniser() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func buttonUISetup() {
        //cancel button
        cancelButton.layer.borderWidth = 0.4
        cancelButton.layer.borderColor = UIColor.babyBlue.cgColor
        cancelButton.layer.cornerRadius = 4
        //add button
        addButton.layer.cornerRadius = 4
    }
    
   override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == rvTypeTextField {
            view.endEditing(true)
            performSegue(withIdentifier: "ShowRVTypesSegue", sender: self)
        }
    }
    
    private func feetAndInchesHandler(height: String, inches: String) -> Float {
        guard let heightFloat = Float(height),
            let inchesFloat = Float(inches) else { return 0.0 }
        //convert heightFloat to inches
        let heightFeetInInches: Float = heightFloat * 12.0
        
        var heightTotalInInches: Float = heightFeetInInches + inchesFloat
        heightTotalInInches /= 12
        return heightTotalInInches
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRVTypesSegue" {
            guard let pickerVC = segue.destination as? RVTypePickerViewController else { return }
            pickerVC.rvTypeDelegate = self
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addVehicleTapped(_ sender: UIButton) {
        guard let vehicleName = vehicleNameTextField.text,
            let heightFeet = heightFeetTextField.text,
            let heightInches = heightInchesTextField.text,
            let widthFeet = widthFeetTextField.text,
            let widthInches = widthInchesTextField.text,
            let lengthFeet = lengthFeetTextField.text,
            let lengthInches = lengthInchesTextField.text,
            let weightString = weightTextField.text,
            let vehicleWeight = Float(weightString),
            let axelCountString = axelCountTextField.text,
            let vehicleAxelCount = Int(axelCountString),
            let vehicleTypeString = rvTypeTextField.text else { return }
        
        let vehicleType: String
        switch vehicleTypeString {
        case VehicleClassDisplayString.classA.rawValue:
            vehicleType = VehicleClassDataBaseRepresentation.classA.rawValue
        case VehicleClassDisplayString.classB.rawValue:
            vehicleType = VehicleClassDataBaseRepresentation.classB.rawValue
        case VehicleClassDisplayString.classC.rawValue:
            vehicleType = VehicleClassDataBaseRepresentation.classC.rawValue
        case VehicleClassDisplayString.fifthWheel.rawValue:
            vehicleType = VehicleClassDataBaseRepresentation.fifthWheel.rawValue
        case VehicleClassDisplayString.tagalong.rawValue:
            vehicleType = VehicleClassDataBaseRepresentation.tagalong.rawValue
        default:
            return
        }
        
        let vehicleHeight = feetAndInchesHandler(height: heightFeet, inches: heightInches)
        let vehicleWidth = feetAndInchesHandler(height: widthFeet, inches: widthInches)
        let vehicleLength = feetAndInchesHandler(height: lengthFeet, inches: lengthInches)
        
        let newVehicle = Vehicle(id: nil, name: vehicleName, height: vehicleHeight, weight: vehicleWeight, width: vehicleWidth, length: vehicleLength, axelCount: vehicleAxelCount, vehicleClass: vehicleType, dualTires: duelWheelSwitch.isOn, trailer: nil)
        
        networkController.createVehicle(with: newVehicle) { error in
                            if let error = error {
                NSLog("Error Creating Vehicle \(error)")
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
}

// MARK: - Extensions

extension AddVehicleViewController: RVTypePickerDelegate {
    func typeOfRVWasChosen(RVType: String) {
        rvTypeTextField.text = RVType
    }
}
