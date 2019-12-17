//
//  SignInViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 12/16/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import SVGKit


class SignInViewController: UIViewController {

    // MARK: - IBOutlets & Properties

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageContainerView: UIView!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navbarUISetUp()
    }
    
    // MARK: - IBActions & Methods
    
    func navbarUISetUp() {
        let rvWayTitle = UIBarButtonItem(title: "RV WAY", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        //rvWayTitle.isEnabled = false
        rvWayTitle.tintColor = .navigationBarTextColor
        navigationController?.navigationBar.barTintColor = .navigationBarBackground
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
