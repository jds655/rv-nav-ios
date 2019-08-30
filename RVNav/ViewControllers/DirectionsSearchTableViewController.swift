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
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    let geocoder = Geocoder.shared
    var addresses: [Placemark] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        startSearchBar.delegate = self
        destinationSearchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = startSearchBar.text else { return }
        search(with: searchTerm)
    }

    func search(with address: String) {
        let options = ForwardGeocodeOptions(query: address)
        options.allowedScopes = [.address, .pointOfInterest]

        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemarks = placemarks else { return }
            self.addresses = placemarks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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


}
