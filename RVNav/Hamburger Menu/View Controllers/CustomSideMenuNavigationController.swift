//
//  CustomSideMenuNavigationController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/15/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import Foundation
import SideMenu

class CustomSideMenuNavigationController: SideMenuNavigationController {
    var modelController: ModelController?
    var mapAPIController: MapAPIControllerProtocol?
    var menuDelegate: MenuDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SideMenuTableViewController
        destinationVC.modelController = self.modelController
        destinationVC.menuDelegate = self.menuDelegate
    }
}

//UINavigationControllerDelegate
extension CustomSideMenuNavigationController: UINavigationControllerDelegate {
    internal func navigationController(_: UINavigationController, willShow: UIViewController, animated: Bool) {
        if willShow is SideMenuTableViewController {
            let destinationVC = willShow as! SideMenuTableViewController
            destinationVC.modelController = self.modelController
            destinationVC.menuDelegate = self.menuDelegate
            destinationVC.mapAPIController = self.mapAPIController
        }
    }
}
