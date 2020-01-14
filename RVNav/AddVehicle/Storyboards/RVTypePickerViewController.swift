//
//  RVTypePickerViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/13/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

protocol RVTypePickerDelegate: AnyObject {
    func typeOfRVWasChosen(RVType: String)
}

class RVTypePickerViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var typePickerContainerView: UIView!
    @IBOutlet weak var RVTypePickerView: UIPickerView!
    @IBOutlet weak var selectTypeButton: UIButton!
    
    // MARK: - Properties
    
    let RVTypes = ["Class A", "Class B", "Class C", "5th Wheel", "Tagalong Camper"]
    var rvTypeDelegate: RVTypePickerDelegate?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        typePickerContainerView.layer.cornerRadius = 30
        typePickerContainerView.layer.shadowRadius = 15
        typePickerContainerView.layer.shadowOffset = .zero
        typePickerContainerView.layer.shadowOpacity = 0.2
        
        selectTypeButton.layer.cornerRadius = 4
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelXTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectTypeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func blankSpaceTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// MARK: - Extensions

extension RVTypePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RVTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RVTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rvTypeDelegate?.typeOfRVWasChosen(RVType: RVTypes[row])
    }

}
