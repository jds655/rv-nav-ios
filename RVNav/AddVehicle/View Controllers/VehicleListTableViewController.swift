//
//  VehicleListTableViewController.swift
//  RVNav
//
//  Created by Jake Connerly on 1/16/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class VehicleListTableViewController: UIViewController {

    let mockVehicles = ["Billy Bad Ass", "Little Timmy", "Joe Rocket", "Frank The Tank"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension VehicleListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mockVehicles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCell", for: indexPath)
        let vehicle = mockVehicles[indexPath.row]
        cell.textLabel?.text = vehicle
        cell.textLabel?.textColor = .white

        return cell
    }
}
