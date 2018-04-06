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
            cell?.valueLabel.attributedText = TextFormatter().fixElectron(config: elementInfo.electronicConfiguration!, font: "BIG")
        } else if indexPath.row == 5 {
            cell?.keyLabel.text = "Atomic Radius"
            cell?.valueLabel.text = elementInfo.atomicRadius
        } else if indexPath.row == 6 {
            cell?.keyLabel.text = "Ion Radius"
            cell?.valueLabel.text = elementInfo.ionRadius
        } else if indexPath.row == 7 {
            if elementInfo.boilingPoint! == "" {
                cell?.keyLabel.text = "Boiling Point"
                cell?.valueLabel.text = elementInfo.boilingPoint
            } else {
                cell?.keyLabel.text = "Boiling Point"
                cell?.valueLabel.text = elementInfo.boilingPoint! + " K"
            }
        } else if indexPath.row == 8 {
            if elementInfo.meltingPoint! == "" {
                cell?.keyLabel.text = "Melting Point"
                cell?.valueLabel.text = elementInfo.meltingPoint
            } else {
                cell?.keyLabel.text = "Melting Point"
                cell?.valueLabel.text = elementInfo.meltingPoint! + " K"
            }
        } else if indexPath.row == 9 {
            cell?.keyLabel.text = "Group"
            cell?.valueLabel.text = elementInfo.groupBlock
        } else if indexPath.row == 10 {
            cell?.keyLabel.text = "Standard State"
            cell?.valueLabel.text = elementInfo.standardState
        } else if indexPath.row == 11 {
            if elementInfo.density! == "" {
                cell?.keyLabel.text = "Density"
                cell?.valueLabel.text = elementInfo.density
            } else {
                cell?.keyLabel.text = "Density"
                cell?.valueLabel.text = elementInfo.density! + " g/mL"
            }
        } else if indexPath.row == 12 {
            cell?.keyLabel.text = "Bonding Type"
            cell?.valueLabel.text = elementInfo.bondingType
        } else if indexPath.row == 13 {
            cell?.keyLabel.text = "Electronegativity"
            cell?.valueLabel.text = elementInfo.electronegativity
        } else if indexPath.row == 14 {
            if elementInfo.ionizationEnergy == "" {
                cell?.keyLabel.text = "Ionization Energy"
                cell?.valueLabel.text = elementInfo.ionizationEnergy
            } else {
                cell?.keyLabel.text = "Ionization Energy"
                cell?.valueLabel.text = elementInfo.ionizationEnergy! + " kJ"
            }
        } else if indexPath.row == 15 {
            if elementInfo.electronAffinity! == "" {
                cell?.keyLabel.text = "Electron Affinity"
                cell?.valueLabel.text = elementInfo.electronAffinity
            } else {
                cell?.keyLabel.text = "Electron Affinity"
                cell?.valueLabel.text = elementInfo.electronAffinity! + " kJ"
            }
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

class ElementInfoObject: NSObject {
    
    var atomicMass: String?
    var atomicNumber: String?
    var atomicRadius: String?
    var boilingPoint: String?
    var bondingType: String?
    var density: String?
    var electronAffinity: String?
    var electronegativity: String?
    var electronicConfiguration: String?
    var groupBlock: String?
    var ionRadius: String?
    var ionizationEnergy: String?
    var meltingPoint: String?
    var name: String?
    var oxidationStates: String?
    var standardState: String?
    var symbol: String?
    var vanDelWaalsRadius: String?
    var yearDiscovered: String?
    var cpkHexColor: String?
    
    init(dictionary: [String: AnyObject]) {
        self.atomicMass = dictionary["atomicMass"] as? String ?? ""
        self.atomicNumber = dictionary["atomicNumber"] as? String ?? ""
        self.atomicRadius = dictionary["atomicRadius"] as? String ?? ""
        self.boilingPoint = dictionary["boilingPoint"] as? String ?? ""
        self.bondingType = dictionary["bondingType"] as? String ?? ""
        self.density = dictionary["density"] as? String ?? ""
        self.electronAffinity = dictionary["electronAffinity"] as? String ?? ""
        self.electronegativity = dictionary["electronegativity"] as? String ?? ""
        self.electronicConfiguration = dictionary["electronicConfiguration"] as? String ?? ""
        self.groupBlock = dictionary["groupBlock"] as? String ?? ""
        self.ionRadius = dictionary["ionRadius"] as? String ?? ""
        self.ionizationEnergy = dictionary["ionizationEnergy"] as? String ?? ""
        self.meltingPoint = dictionary["meltingPoint"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.oxidationStates = dictionary["oxidationStates"] as? String ?? ""
        self.standardState = dictionary["standardState"] as? String ?? ""
        self.symbol = dictionary["symbol"] as? String ?? ""
        self.vanDelWaalsRadius = dictionary["vanDelWaalsRadius"] as? String ?? ""
        self.yearDiscovered = dictionary["yearDiscovered"] as? String ?? ""
        self.cpkHexColor = dictionary["cpkHexColor"] as? String ?? ""
    }
}

