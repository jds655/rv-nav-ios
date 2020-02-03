//
//  RouteResultsViewController.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/28/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit
import ArcGIS

class RouteResultsViewController: UIViewController {

    // MARK: - Properties
    var routeController: RouteController?
    var mapAPIController: MapAPIControllerProtocol?
    var routeInfo: RouteInfo? {
        didSet{
            ARSLineProgress.show()
            guard let routeInfo = routeInfo else { return }
            mapAPIController?.fetchRoute(from: routeInfo) { (route, error) in
                if let error = error {
                    #warning("give user an error here.")
                    return
                }
                if let route = route {
                    self.route = route
                }
                ARSLineProgress.hide()
            }
        }
    }
    var route: AGSRoute?{
        didSet{
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var endingLocationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .darkBlue
        view.backgroundColor = .darkBlue
    }
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: Any) {
        guard let route = route else { return }
        mapAPIController?.selectedRoute = route
        //dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "unwindToMapViewWithSegue", sender: self)
    }
    
    @IBAction func backtapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func updateViews() {
        guard let route = route else { return }
        DispatchQueue.main.async {
            let totalTimeString = String(route.totalTime)
            #warning("Flesh this out")
            //let startLocation = route
            self.totalTimeLabel.text = totalTimeString
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extensions

extension RouteResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route?.directionManeuvers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteResultTableViewCell", for: indexPath) as? RouteResultTableViewCell else { return UITableViewCell() }
        if let route = route {
            let maneuver = route.directionManeuvers[indexPath.row]
            cell.leftImageView.image = maneuver.maneuverType.image()
            cell.labelView.text = maneuver.directionText
        }
        let view = UIView()
        view.backgroundColor = .darkBlue
        cell.selectedBackgroundView = view
        cell.backgroundColor = .darkBlue
        return cell
    }
}
