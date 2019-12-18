//
//  OnboardingViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 12/17/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

struct FormData {
    var email: String?
    var password: String?
    var username: String?
    var firstname: String?
    var lastname: String?
    var age: Int?
    func readyPage1() ->  Bool {
        guard let email = self.email,
            !email.isEmpty,
            let password = self.password,
            !password.isEmpty else {
                return false
        }
        return true
    }
    func readyPage2() ->  Bool {
        guard let username = self.username,
            !username.isEmpty,
            let firstname = self.firstname,
            !firstname.isEmpty,
            let lastname = self.lastname,
            !lastname.isEmpty,
            let _ = self.age else {
                return false
        }
        return true
    }
}

class OnboardingViewController: ShiftableViewController {
    
    // MARK: - Properties
    private var formData = FormData()
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageContainerView: UIView!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        tapOutsideToDismissKeyBoard()
    }
    
    // MARK: - IBActions
    @IBAction func onwardTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Onboarding2", sender: self)
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
    }
    
    // MARK: - Private Methods
    private func UISetup() {
        
        googleFacebookButtonUISetup()
        signUpButtonButtonUISetup()
    }
    
    private func googleFacebookButtonUISetup() {
        //Google Button UI Set Up
        googleSignInButton.layer.cornerRadius = 4
        googleSignInButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        googleSignInButton.layer.borderWidth = 0.2
        
        //Facebook Button UI Set Up
        facebookSignInButton.layer.cornerRadius = 4
        facebookSignInButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        googleSignInButton.layer.borderWidth = 0.2
    }
    
    private func signUpButtonButtonUISetup() {
        signUpButton.layer.borderWidth = 0.4
        signUpButton.layer.cornerRadius = 4
        if self.formData.readyPage1() {
            signInButton.isEnabled = true
        signInButton.backgroundColor = .navigationBarTextColor
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = .clear
            
        }
    }
    
    private func tapOutsideToDismissKeyBoard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Onboarding2":
            guard let vc = segue.destination as? Onboarding2ViewController else { return }
            vc.formData = self.formData
        default:
            break
        }
    }
    
}

// MARK: - Extensions
extension OnboardingViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            guard let email = emailTextField.text,
                !email.isEmpty else {
                    return false
            }
            formData.email = email
            passwordTextField.becomeFirstResponder()
            return true
        case passwordTextField:
            guard let password = passwordTextField.text,
                !password.isEmpty else {
                    return false
            }
            formData.password = password
            password2TextField.becomeFirstResponder()
            return true
        case password2TextField:
            guard let passwordconf = password2TextField.text,
                !passwordconf.isEmpty else {
                    return false
            }
            guard passwordconf == formData.password else {
                #warning("Display alert about passwords not matching")
                return false
            }
            signUpButtonButtonUISetup()
            return true
        default:
            return true
        }
    }
}
