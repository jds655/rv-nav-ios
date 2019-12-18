//
//  OnboardingLoginViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 12/16/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class OnboardingLoginViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performSegue(withIdentifier: "OnboardingSegue", sender: self)
    }
    
}
