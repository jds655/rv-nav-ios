//
//  UIViewLoadingProtocol.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/25/20.
//  Copyright © 2020 RVNav. All rights reserved.
//
import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {

  // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib(named: String) -> Self {
    //let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
    let nib = UINib(nibName: named, bundle: nil)
    return nib.instantiate(withOwner: self, options: nil).first as! Self
  }

}
