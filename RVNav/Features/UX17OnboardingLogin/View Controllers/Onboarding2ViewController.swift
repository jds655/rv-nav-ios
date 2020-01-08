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
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        UISetup()
        tapOutsideToDismissKeyBoard()
        //firstNameTextField.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - IBActions
    @IBAction func onwardTapped(_ sender: Any) {
        guard let formData = formData else { return }
        let user = User(firstName: formData.firstname,
                        lastName: formData.lastname,
                        password: formData.password,
                        email: formData.email,
                        username: formData.username)
        networkController?.register(with: user) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("\(error)")
                    let alert = UIAlertController(title: "Error", message: "Registration Failed:  \(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    Analytics.logEvent("register", parameters: nil)
                    guard let email = formData.email,
                        let password = formData.password,
                        !email.isEmpty,
                        !password.isEmpty else { return }
                    
                    let signInInfo = SignInInfo(email: email, password: password)
                    self.networkController.signIn(with: signInInfo) { (error) in
                        if let error = error {
                            NSLog("Error signing in: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "unwindToMapView", sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        onwardTapped(self)
    }
    
    
    // MARK: - Private Methods
    private func UISetup() {
        signUpButtonButtonUISetup()
        skipButton.setTitleColor(.skipTextColor, for: .normal)
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func textFieldValidation (_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            guard let firstName = firstNameTextField.text,
                !firstName.isEmpty else {
                    textField.resignFirstResponder()
                    return true
            }
            formData?.firstname = firstName
            dismissKeyboard()
            lastNameTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case lastNameTextField:
            guard let lastName = lastNameTextField.text,
                !lastName.isEmpty else {
                    textField.resignFirstResponder()
                    return true
            }
            formData?.lastname = lastName
            dismissKeyboard()
            usernameTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case usernameTextField:
            guard let username = usernameTextField.text,
                !username.isEmpty else {
                    textField.resignFirstResponder()
                    return true
            }
            formData?.username = username
            dismissKeyboard()
            ageTextField.becomeFirstResponder()
            signUpButtonButtonUISetup()
            return true
        case ageTextField:
            guard let ageString = ageTextField.text,
                !ageString.isEmpty else {
                    textField.resignFirstResponder()
                    return true
            }
            guard let age = Int(ageString),
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

// MARK: - Extensions
extension Onboarding2ViewController {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
            !text.isEmpty else {
                dismissKeyboard()
                return true
        }
        return textFieldValidation(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textFieldValidation(textField)
    }
}
