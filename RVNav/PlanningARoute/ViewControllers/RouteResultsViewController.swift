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
    var route: Route?{
        didSet{
            
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var startingLocationLabel: UILabel!
    @IBOutlet weak var endingLocationLabel: UILabel!
    
    
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
        guard let route = route else { return }
        routeController?.add(route: route)
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
        
    }

}

// MARK: - Extensions

extension RouteResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
//        let view = UIView()
//        view.backgroundColor = .darkBlue
//        cell.selectedBackgroundView = view
//        return cell
    }
    
    
}
