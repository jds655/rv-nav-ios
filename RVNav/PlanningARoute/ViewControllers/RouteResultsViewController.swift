//
//  RouteResultsViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/28/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class RouteResultsViewController: UIViewController {

    // MARK: - Properties
    #warning("Either add AGSRoute to this Struct or pass AGS one")
    var routeController: RouteController?
    var route: Route?
    
    // MARK: - IBOutlets
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func updateViews() {
        guard let route = route else { return }
        
    }

}

// MARK: - Extensions

