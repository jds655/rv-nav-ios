//
//  SignInViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 12/16/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - IBOutlets & Properties

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageContainerView: UIView!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
    }
    
    // MARK: - IBActions & Methods
    
    private func UISetup() {
        navbarUISetup()
        googleFacebookButtonUISetup()
        signInButtonButtonUISetup()
    }
    
    func navbarUISetup() {
        let rvWayTitle = UIBarButtonItem(title: "RV WAY", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        //rvWayTitle.isEnabled = false
        rvWayTitle.tintColor = .navigationBarTextColor
        navigationController?.navigationBar.barTintColor = .navigationBarBackground
        self.navigationItem.leftBarButtonItem = rvWayTitle
    }
    
    func googleFacebookButtonUISetup() {
        //Google Button UI Set Up
        googleSignInButton.layer.cornerRadius = 4
        googleSignInButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        googleSignInButton.layer.borderWidth = 0.2
        
        //Facebook Button UI Set Up
        facebookSignInButton.layer.cornerRadius = 4
        facebookSignInButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        googleSignInButton.layer.borderWidth = 0.2
    }
    
    func signInButtonButtonUISetup() {
        signInButton.layer.borderWidth = 0.4
        signInButton.layer.cornerRadius = 4
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
    

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
