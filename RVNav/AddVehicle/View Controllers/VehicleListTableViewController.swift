//
//  VehicleListTableViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class VehicleListTableViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var mockVehicles: [Vehicle] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockVehicles()
    }
    
    // MARK: - Private Methods
    
    private func createMockVehicles() {
        mockVehicles.append(Vehicle(id: 0, name: "Billy Bad Ass", height: 44.6, weight: 5000, width: 44.5554, length: 53, axelCount: 3, vehicleClass: "ClassA", dualTires: true, trailer: nil))
        mockVehicles.append(Vehicle(id: 1, name: "Little Timmy", height: 4.6, weight: 1000, width: 4.5554, length: 3, axelCount: 3, vehicleClass: "tagalong", dualTires: true, trailer: nil))
        mockVehicles.append(Vehicle(id: 2, name: "Joe Rocket", height: 44.6, weight: 5000, width: 44.5554, length: 53, axelCount: 3, vehicleClass: "ClassA", dualTires: true, trailer: nil))
    }
    
    // MARK: - IBActions
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension VehicleListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mockVehicles.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)
            
            let vehicle = mockVehicles[indexPath.row]
            vehicleCell.textLabel?.text = vehicle.name
            vehicleCell.textLabel?.textColor = .white
            
            return vehicleCell
        } else {
            guard let addVehicleCell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleCell") else { return UITableViewCell() }
            addVehicleCell.textLabel?.text = "+ Add New Vehicle"
            return addVehicleCell
        }
    }
}
