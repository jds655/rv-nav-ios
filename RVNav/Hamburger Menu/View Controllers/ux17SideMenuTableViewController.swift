//
//  ux17SideMenuTableViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/13/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class ux17SideMenuTableViewController: UITableViewController {

  

    // This is the array that the tableview data source uses for menu options.
    
    var menuItemController = MenuItemController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
     tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return menuItemController.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuItemController.sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItemController.sections[section].menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuItemTableViewCell else { return UITableViewCell() }

        let menuItem = menuItemController.sections[indexPath.section].menuItems[indexPath.row]
        
        cell.menuItem = menuItem

        return cell
    }

    // The switch determines which index of the menu array you are tapping.
    // TODO: - Set up a case for 1 - "RVSettings", 2 - "Contact Us", 3 - "Privacy Agreement"
    #warning("Redo this logic")
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "ShowVehichleInfo", sender: nil)
        default:
            print("No item selected")
        }
    }
}
