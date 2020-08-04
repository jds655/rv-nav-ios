//
//  Alerts.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 2/4/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

func showAlert(on target: UIViewController, title: String, message: String, completion: @escaping () -> Void = {}) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    alert.addAction(action)
    DispatchQueue.main.async {
        target.present(alert, animated: true, completion: completion)
    }
}
