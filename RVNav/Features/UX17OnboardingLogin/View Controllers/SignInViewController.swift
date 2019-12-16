//
//  SignInViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 12/16/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navbarUISetUp()
    }
    
    func navbarUISetUp() {
        let rvWayTitle = UIBarButtonItem(title: "RV WAY", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        rvWayTitle.isEnabled = false
        rvWayTitle.tintColor = .navigationBarTextColor
        self.navigationItem.leftBarButtonItem = rvWayTitle
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
