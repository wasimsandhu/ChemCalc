//
//  ElementInfoViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/9/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

var elements = [ElementInfoObject]()

class ElementInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var elementInfo: ElementInfoObject!
    var databaseIndex: Int?
    
    @IBOutlet weak var elementInfoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        elementInfo = elements[databaseIndex!]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = elementInfo.name
        
        // Element data from: https://github.com/andrejewski/periodic-table
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Elements").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async(execute: {
                self.elementInfoTableView.reloadData()
            })
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Element Data"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementinfocell", for: indexPath) as? ElementInfoCell
        
        if indexPath.row == 0 {
            cell?.keyLabel.text = "Name"
            cell?.valueLabel.text = elementInfo.name
        } else if indexPath.row == 1 {
            cell?.keyLabel.text = "Symbol"
            cell?.valueLabel.text = elementInfo.symbol
        } else if indexPath.row == 2 {
            cell?.keyLabel.text = "Atomic Number"
            cell?.valueLabel.text = elementInfo.atomicNumber
        } else if indexPath.row == 3 {
            cell?.keyLabel.text = "Atomic Mass"
            cell?.valueLabel.text = elementInfo.atomicMass
        } else if indexPath.row == 4 {
            cell?.keyLabel.text = "Electron Configuration"
            cell?.valueLabel.attributedText = TextFormatter().fixElectron(config: elementInfo.electronicConfiguration!)
        } else if indexPath.row == 5 {
            cell?.keyLabel.text = "Atomic Radius"
            cell?.valueLabel.text = elementInfo.atomicRadius
        } else if indexPath.row == 6 {
            cell?.keyLabel.text = "Ion Radius"
            cell?.valueLabel.text = elementInfo.ionRadius
        } else if indexPath.row == 7 {
            cell?.keyLabel.text = "Boiling Point"
            cell?.valueLabel.text = elementInfo.boilingPoint! + "°C"
        } else if indexPath.row == 8 {
            cell?.keyLabel.text = "Melting Point"
            cell?.valueLabel.text = elementInfo.meltingPoint! + "°C"
        } else if indexPath.row == 9 {
            cell?.keyLabel.text = "Group"
            cell?.valueLabel.text = elementInfo.groupBlock
        } else if indexPath.row == 10 {
            cell?.keyLabel.text = "Standard State"
            cell?.valueLabel.text = elementInfo.standardState
        } else if indexPath.row == 11 {
            cell?.keyLabel.text = "Density"
            cell?.valueLabel.text = elementInfo.density! + " g/mL"
        } else if indexPath.row == 12 {
            cell?.keyLabel.text = "Bonding Type"
            cell?.valueLabel.text = elementInfo.bondingType
        } else if indexPath.row == 13 {
            cell?.keyLabel.text = "Electronegativity"
            cell?.valueLabel.text = elementInfo.electronegativity
        } else if indexPath.row == 14 {
            cell?.keyLabel.text = "Ionization Energy"
            cell?.valueLabel.text = elementInfo.ionizationEnergy! + " kJ"
        } else if indexPath.row == 15 {
            cell?.keyLabel.text = "Electron Affinity"
            cell?.valueLabel.text = elementInfo.electronAffinity! + " kJ"
        } else if indexPath.row == 16 {
            cell?.keyLabel.text = "Oxidation States"
            cell?.valueLabel.text = elementInfo.oxidationStates
        } else if indexPath.row == 17 {
            cell?.keyLabel.text = "Van der Waals Radius"
            cell?.valueLabel.text = elementInfo.vanDelWaalsRadius
        } else if indexPath.row == 18 {
            cell?.keyLabel.text = "Year Discovered"
            cell?.valueLabel.text = elementInfo.yearDiscovered
        }
        
        return cell!
    }
    
}

class ElementInfoCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
