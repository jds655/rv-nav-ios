//
//  MapViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/19/19.
//  Copied bu Joshua Sharp on 01/13/2020
//  Notes: Migrated UI over to new ux17 Design

//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAnalytics
//import Contacts
import CoreLocation
import ArcGIS


class ux17MapViewController: UIViewController {
    
    // MARK: - Properties
    private var modelController: ModelController = ModelController(userController: UserController())
    private var directionsController: DirectionsControllerProtocol = DirectionsController(mapAPIController: AGSMapAPIController(avoidanceController: AvoidanceController()))
    
    
    // MARK: - IBOutlets
    @IBOutlet private var mapView: AGSMapView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("app_opened", parameters: nil)
        self.directionsController.delegate = self
        mapView.locationDisplay.autoPanMode = .compassNavigation
        mapView.locationDisplay.start(completion: nil)
        //self.mapView = directionsController.mapAPIController.mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.isFirstLaunch() { //Show Landing Page on first launch
            performSegue(withIdentifier: "LandingPageSegue", sender: self)
        } else if KeychainWrapper.standard.string(forKey: "accessToken") == nil && !UserDefaults.isFirstLaunch() { //Go to Signin
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            let destinationVC = segue.destination as! SignInViewController
            destinationVC.userController = modelController.userController
        }
        if segue.identifier == "ShowAddressSearch" {
        }
        if segue.identifier == "LandingPageSegue" {
            let destinationVC = segue.destination as! LandingPageViewController
            destinationVC.userController = modelController.userController
        }
        if segue.identifier == "HamburgerMenu" {
            let destinationVC = segue.destination as! CustomSideMenuNavigationController
            destinationVC.modelController = modelController
            destinationVC.menuDelegate = self
        }
    }
    
    // MARK: - IBActions
    @IBAction func logOutButtonTapped(_ sender: Any) {
        modelController.userController.logout {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
            }
        }
    }
    
    //Unwind segue to unwind back to here
    @IBAction func unwindToMapView(segue:UIStoryboardSegue) { }
    
    // MARK: - Private Methods
}

extension ux17MapViewController: MenuDelegateProtocol {
    func performSelector(selector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        performSelector(onMainThread: selector, with: arg, waitUntilDone: wait)
    }
    
    func performSegue(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}

extension ux17MapViewController: ViewDelegateProtocol {
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}
