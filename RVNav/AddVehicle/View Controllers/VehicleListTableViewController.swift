//
//  VehicleListTableViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class VehicleListTableViewController: UIViewController {
    
    // MARK: - Properties
    var vehicleController: VehicleModelControllerProtocol?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        vehicleController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    // MARK: - IBActions
    
    @IBAction func unwindToVehicleList(segue:UIStoryboardSegue) { }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vehicleController = vehicleController else { return }
        if segue.identifier == "EditVehicleSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let editVehicleVC = segue.destination as? AddVehicleViewController else {
                    print("error getting segue destination")
                    return }
            let vehicle = vehicleController.vehicles[indexPath.row]
            editVehicleVC.vehicleController = vehicleController
            editVehicleVC.vehicle = vehicle
        } else {
            guard let editVehicleVC = segue.destination as? AddVehicleViewController else { return }
            editVehicleVC.vehicleController = vehicleController
        }
    }
}

// MARK: - Extensions

extension VehicleListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return vehicleController?.vehicles.count ?? 0
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)
            
            let vehicle = vehicleController?.vehicles[indexPath.row]
            vehicleCell.textLabel?.text = vehicle?.name
            vehicleCell.textLabel?.textColor = .white
            
            return vehicleCell
        } else {
            // Gives us the Add new vehicle option
            guard let addVehicleCell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleCell") else { return UITableViewCell() }
            addVehicleCell.textLabel?.text = "+ Add New Vehicle"
            return addVehicleCell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let vehicle = vehicleController?.vehicles[indexPath.row] else { return }
            vehicleController?.deleteVehicle(vehicle: vehicle, completion: { (vehicle, error) in
                if let error = error {
                    print ("Error Deleting Vehicle: \(error)")
                } else {
                    //Update?
                }
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension VehicleListTableViewController: VehicleModelDataDelegate {
    func didStartFetchingData() {
        ARSLineProgress.show()
    }
    
    func didEndFetchingData(error: VehicleModelControllerError?) {
        if let error = error {
            ARSLineProgress.showFail()
        } else {
            ARSLineProgress.hide()
        }
    }
    
    func dataDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
