//
//  SelectLocationTextField.swift
//  RVNav
//
//  Created by Lambda_School_Loaner_214 on 1/25/20.
//  Copyright © 2020 RVNav. All rights reserved.
//

import UIKit

@IBDesignable
class SelectLocationTextField: UIView {

    // MARK: - Properties
    var delegate: SelectALocationDelegate?
    @IBInspectable var label: String? {
        didSet {
            labelView.text = self.label
        }
    }
    var location: AddressProtocol?{
        didSet{
            self.label = location?.address
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        get{
            return leftImageView.image
        }
        set {
            leftImageView.image = newValue
            setNeedsDisplay()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }

    func initNib() {
        let bundle = Bundle(for: SelectLocationTextField.self)
        bundle.loadNibNamed("SelectLocationTextField", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        //Configure anything that may need outlets here
    }
    
    @IBAction private func tapped(_ sender: Any) {
        print("SelectLocationControl:  internal button tapped-up now.")
        delegate?.openSelectALocation(target: self)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        //let view = UIView.loadFromNib(named:"SelectLocationTextField")
        //addSubview(view)
        //view.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

extension SelectLocationTextField: SelectALocationDelegate {
    func locationSelected(location: AddressProtocol) {
        self.location = location
    }
    
    func openSelectALocation(target: SelectALocationDelegate) {
        //nothing should be needed here
    }
}
