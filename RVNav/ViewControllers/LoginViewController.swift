//
//  LoginViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/20/19.
//  Copyright © 2019 RVNav. All rights reserved.
//


import UIKit
import FirebaseAnalytics

enum SignInType {
    case signUp
    case logIn
}


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!

    var signInType = SignInType.logIn
    var networkController: NetworkController?

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTypeSegmentedControl.selectedSegmentIndex = 1
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        emailTextField.isHidden = true
        signInButton.setTitle("Log In", for: .normal)
    }

    @IBAction func signInTypeChanged(_ sender: Any) {
        if loginTypeSegmentedControl.selectedSegmentIndex == 0 {
            signInType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
            firstNameTextField.isHidden = false
            lastNameTextField.isHidden = false
            emailTextField.isHidden = false
        } else if loginTypeSegmentedControl.selectedSegmentIndex == 1{
            signInType = .logIn
            signInButton.setTitle("Log In", for: .normal)
            firstNameTextField.isHidden = true
            lastNameTextField.isHidden = true
            emailTextField.isHidden = true
        }
    }

    @IBAction func authenticate(_ sender: Any) {

        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let password = passwordTextField.text,
            !password.isEmpty,
            let username = usernameTextField.text,
            !username.isEmpty,
            let email = emailTextField.text else { return }

        switch signInType {

        case .signUp:

            let user = User( firstName: firstName, lastName: lastName, password: password, vehicleClass: email, username: username)

            networkController?.register(with: user) { (error) in
                if let error = error {
                    NSLog("\(error)")

                }
                Analytics.logEvent("register", parameters: nil)

            }

        case .logIn:
            let signInInfo = SignInInfo(username: username, password: password)
            networkController?.signIn(with: signInInfo) { (error) in
                if let error = error {
                    NSLog("Error signing up: \(error)")
                    let alert = UIAlertController(title: "Username or Password incorrect", message: "Please try again.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(alertAction)

                    self.present(alert, animated: true)
            }
                guard let message = self.networkController?.result?.message else { return }
                print(message)
                if self.networkController?.result?.token != nil {
                    Analytics.logEvent("login", parameters: nil)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                        }


        self.view.endEditing(true)




        }
    }
}
