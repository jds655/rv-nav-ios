//
//  PlanARouteViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/23/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit


class PlanARouteViewController: UIViewController {

    // MARK: - Properties
    var vehicleController: VehicleModelControllerProtocol? {
        didSet {
            setVehicleDataSource()
        }
    }
    private var route: Route? {
        didSet{
            #warning("kick off call to get route and refresh UI")
        }
    }
    
    // MARK: - IBOutlets
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - Private Methods
    
    private func setVehicleDataSource() {
        #warning("Flesh this out...")
    }
    
    private func updateViews () {
        
    }
    
// MARK: - Extensions
}
