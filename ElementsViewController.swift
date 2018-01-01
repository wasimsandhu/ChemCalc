//
//  ElementsViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class ElementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var elementNames = ["Hydrogen", "Helium", "Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon", "Sodium", "Magnesium", "Aluminum", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium", "Tin", "Antimony", "Tellurium", "Iodine", "Xenon", "Cesium", "Barium", "Lanthanum", "Cerium", "Praseodymium", "Neodymium", "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium", "Hafnium", "Tantalum", "Tungsten", "Rhenium", "Osmium", "Iridium", "Platinum", "Gold", "Mercury", "Thallium", "Lead", "Bismuth", "Polonium", "Astatine", "Radon", "Francium", "Radium", "Actinium", "Thorium", "Protactinium", "Uranium", "Neptunium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Mendelevium", "Nobelium", "Lawrencium", "Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium", "Darmstadtium", "Roentgenium", "Ununbium", "Nihonium", "Ununquadium", "Moscovium", "Ununhexium", "Tennessine", "Oganesson"]
    
    var elementGroups = [1, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    var elementSymbolDict: [String:String] = [:]
    var elementGroupDict: [String:Int] = [:]
    
    @IBOutlet weak var table: UITableView!
    var cell: ElementTableViewCell?
    
    // objects for search functions
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredElements = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        // merge arrays into dictionaries
        // https://stackoverflow.com/questions/32140969/how-can-i-merge-two-arrays-into-a-dictionary
        for (a, b) in elementNames.enumerated() {
            elementSymbolDict[b] = elementSymbols[a]
        }
        
        for (a, b) in elementNames.enumerated() {
            elementGroupDict[b] = elementGroups[a]
        }
        
    }

    /* TABLE VIEW */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredElements.count
        } else {
            return elementNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ElementTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        cell?.elementName.text = elementNames[indexPath.row]
        cell?.symbol.text = elementSymbols[indexPath.row]
        cell?.atomicNumber.text = "Atomic Number (Z): " + String(indexPath.row + 1)
        cell?.atomicNumber2.text = String(indexPath.row + 1)
        cell?.massNumber.text = "Molar Mass (A): " + String(atomicMasses[indexPath.row])
        cell?.massNumber2.text = String(atomicMasses[indexPath.row])
        cell?.groupName.text = "Group: " + String(elementGroups[indexPath.row])
        
        // color-coding for different groups: http://uicolor.xyz/#/hex-to-ui
        let group = cell!.groupName.text
        
        if (group == "Group: 1") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        } else if (group == "Group: 2") {
            cell!.symbolBackground.backgroundColor = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
        } else if (group == "Group: 3" || group == "Group: 4" || group == "Group: 5" || group == "Group: 6" || group == "Group: 7" || group == "Group: 8" || group == "Group: 9" || group == "Group: 10" || group == "Group: 11" || group == "Group: 12") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        } else if (group == "Group: 13") {
            cell!.symbolBackground.backgroundColor = UIColor(red:1.00, green:0.34, blue:0.13, alpha:1.0)
        } else if (group == "Group: 14") {
            cell!.symbolBackground.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        } else if (group == "Group: 15") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.70, green:0.62, blue:0.86, alpha:1.0)
        } else if (group == "Group: 16") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.65, green:0.84, blue:0.65, alpha:1.0)
        } else if (group == "Group: 17") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.97, green:0.73, blue:0.82, alpha:1.0)
        } else if (group == "Group: 18") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
        } else if (group == "Group: 101") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.80, green:0.86, blue:0.22, alpha:1.0)
        } else if (group == "Group: 102") {
            cell!.symbolBackground.backgroundColor = UIColor(red:0.61, green:0.15, blue:0.69, alpha:1.0)
        }
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
