//
//  DirectionsSearchTableViewController.swift
//  RVNav
//
//  Created by Jonathan Ferrer on 8/30/19.
//  Copyright © 2019 RVNav. All rights reserved.
//

import UIKit
import MapboxGeocoder

class DirectionsSearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var startSearchBar: UISearchBar!
    let geocoder = Geocoder.shared
    var directionsController: DirectionsController?
    var addresses: [Placemark] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startSearchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = startSearchBar.text,
        let directionsController = directionsController else { return }
        directionsController.search(with: searchTerm) { (addresses) in
            if let addresses = addresses {
                self.addresses = addresses
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }




    // MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addresses.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        let address = addresses[indexPath.row]

        cell.textLabel?.text = address.qualifiedName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let directionsController = directionsController else { return }
        let address = addresses[indexPath.row]
        directionsController.destinationAddress = address
        dismiss(animated: true, completion: nil)
    }


}
