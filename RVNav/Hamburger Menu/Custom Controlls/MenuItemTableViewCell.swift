//
//  MenuItemTableViewCell.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/13/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    // MARK: - Properties
    var menuItem: MenuItem? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateViews() {
        guard let menuItem = menuItem else { return }
        self.imageView.image = UIImage(named: menuItem.imageName)
        self.label.text = menuItem.label
    }
}
