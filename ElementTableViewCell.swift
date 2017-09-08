//
//  ElementTableViewCell.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class ElementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var atomicNumber: UILabel!
    @IBOutlet weak var massNumber: UILabel!
    @IBOutlet weak var symbolBackground: UIView!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var elementName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
