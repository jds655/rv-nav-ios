//
//  Onboarding2ViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 12/17/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class Onboarding2ViewController: ShiftableViewController {
    
    // MARK: - Properties
    var formData: FormData?
    var networkController: NetworkController!
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageContainerView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        tapOutsideToDismissKeyBoard()
        firstNameTextField.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func signinTapped(_ sender: Any) {
    }
    
    @IBAction func onwardTapped(_ sender: Any) {
        guard let formData = formData else { return }
        let user = User(firstName: formData.firstname!,
                        lastName: formData.lastname!,
                        password: formData.password!,
                        email: formData.email!,
                        username: formData.username!)
        networkController?.register(with: user) { (error) in
            if let error = error {
                NSLog("\(error)")
                #warning("Add alert of failure to register")
            } else {
                Analytics.logEvent("register", parameters: nil)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToMapView", sender: self)
                }
            }
        }
        self.performSegue(withIdentifier: "unwindToMapView", sender: self)
    }
    
    // MARK: - Private Methods
    private func UISetup() {
        signUpButtonButtonUISetup()
    }
    
    private func signUpButtonButtonUISetup() {
        guard let formData = formData else { return }
        signUpButton.layer.borderWidth = 0.4
        signUpButton.layer.cornerRadius = 4
        if formData.readyPage2() {
            signUpButton.isEnabled = true
        signUpButton.backgroundColor = .babyBlue
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .clear
        }
    }
    
    private func tapOutsideToDismissKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - Extensions
extension Onboarding2ViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            guard let firstName = firstNameTextField.text,
                !firstName.isEmpty else {
                return false
            }
            formData?.firstname = firstName
            dismissKeyboard()
            lastNameTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case lastNameTextField:
            guard let lastName = lastNameTextField.text,
                !lastName.isEmpty else {
                return false
            }
            formData?.lastname = lastName
            dismissKeyboard()
            usernameTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case usernameTextField:
            guard let username = usernameTextField.text,
                !username.isEmpty else {
                return false
            }
            formData?.username = username
            dismissKeyboard()
            ageTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case ageTextField:
            guard let ageString = ageTextField.text,
                !ageString.isEmpty,
                let age = Int(ageString),
                age > 0 && age < 120 else {
                return false
            }
            formData?.age = age
            dismissKeyboard()
            signUpButtonButtonUISetup()
            return true
        default:
            return true
        }
    }
}
