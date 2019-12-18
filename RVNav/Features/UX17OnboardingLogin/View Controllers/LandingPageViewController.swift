//
//  LandingPageViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 12/17/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonUISetup()
    }
    
    // MARK: - IBActions & Methods
    
    private func buttonUISetup() {
        // Login Button UI
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.babyBlue.cgColor
        loginButton.titleLabel?.textColor = .babyBlue
        loginButton.layer.cornerRadius = 4
        
        // Get Started Button UI
        getStartedButton.backgroundColor = .mustardYellow
        getStartedButton.layer.cornerRadius = 4
    }
    
    // Any of the three buttons (Login, Get Started or Let's GO) lead to the "Sign Up" Flow
    @IBAction func anyButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.present(OnboardingLoginViewController, animated: true, completion: nil)
    }
    

}

// MARK: - Extensions

extension LandingPageViewController: UIScrollViewDelegate {
}
