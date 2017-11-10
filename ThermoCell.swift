//
//  ThermoCell.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 10/17/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class ThermoCell: UITableViewCell {

    @IBOutlet weak var compoundLabel: UILabel!
    @IBOutlet weak var deltaValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
