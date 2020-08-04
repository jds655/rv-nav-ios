//
//  RouteResultTableViewCell.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/31/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class RouteResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        leftImageView.image = nil
        labelView.text = nil
    }
}
