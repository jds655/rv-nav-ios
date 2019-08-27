//
//  VehicleFormViewController.swift
//  RVNav
//
//  Created by Ryan Murphy on 8/26/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class VehicleFormViewController: UIViewController {
    
    var storedVehicle: Vehicle?
    var storedVehicleId: Int?
    let networkController = NetworkController()
    @IBOutlet weak var vehicleHeightTextField: UITextField!
    @IBOutlet weak var vehicleWeightTextField: UITextField!
    @IBOutlet weak var vehicleWidthTextField: UITextField!
    @IBOutlet weak var vehicleLengthTextField: UITextField!
    @IBOutlet weak var axleCountTextField: UITextField!
    @IBOutlet weak var vehicleClassSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasDualTiresSwitch: UISwitch!
    @IBOutlet weak var hasTrailerSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        networkController.getVehicle { (vehicle, error) in
            if let error = error {
                NSLog("Error Pulling Vehcile from Server \(error)")
                print("Couldn't load vehicle")
                return
            }
            
            UserDefaults.standard.set(vehicle?.id, forKey: "VehicleId")
            print("Vehicle Set")
            
            self.storedVehicleId = UserDefaults.standard.integer(forKey: "VehicleId")
            
        }
    }


    @IBAction func saveButtonPressed(_ sender: Any) {

        guard let height = vehicleWeightTextField.text,
            let weight = vehicleWeightTextField.text,
            let width = vehicleWidthTextField.text,
            let length = vehicleLengthTextField.text,
            let axleCount = axleCountTextField.text else { return }
        var vehicleClass: String?
        switch vehicleClassSegmentedControl.selectedSegmentIndex {
        case 0:
            vehicleClass = "A"
        case 1:
            vehicleClass = "B"
        case 2:
            vehicleClass = "C"
        case 3:
            vehicleClass = "D"
        default:
            break;
        }

        let vehicle = Vehicle(id: nil, height: Float(height), weight: Float(weight), width: Float(width), length: Float(length), axelCount: Int(axleCount), vehicleClass: vehicleClass, dualTires: hasDualTiresSwitch.isOn, trailer: hasTrailerSwitch.isOn)

        
        if storedVehicleId == nil {
        networkController.createVehicle(with: vehicle) { (error) in
            if let error = error {
                NSLog("Error creating vehicle: \(error)")
            }
            
        }
        print("Vehicle Added")
        } else {
            networkController.editVehicle(with: vehicle, id: storedVehicleId!) { (error) in
                if let error = error {
                    NSLog("Error editing vehicle: \(error)")
                }
            }
        print("Vehicle Edited")
        }
    }

    @IBAction func vehicleClassChanged(_ sender: UISegmentedControl) {
        print("Class Changed")
        }

}
