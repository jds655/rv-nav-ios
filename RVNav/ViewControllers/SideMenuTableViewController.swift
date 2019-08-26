//
//  SideMenuTableViewController.swift
//  RVNav
//
//  Created by Ryan Murphy on 8/26/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    let menu: [String] = ["Vehicle Information", "Settings", "Contact Us", "Privacy Agreement"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
     tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)

        let menuItem = menu[indexPath.row]
        
        cell.textLabel?.text = menuItem

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "ShowVehichleInfo", sender: nil)
        default:
            print("No item selected")
        }
    }
 
    
    
}
