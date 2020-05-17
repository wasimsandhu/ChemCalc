//
//  ElementsViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ElementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var elementNames = ["Hydrogen", "Helium", "Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon", "Sodium", "Magnesium", "Aluminum", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium", "Tin", "Antimony", "Tellurium", "Iodine", "Xenon", "Cesium", "Barium", "Lanthanum", "Cerium", "Praseodymium", "Neodymium", "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium", "Hafnium", "Tantalum", "Tungsten", "Rhenium", "Osmium", "Iridium", "Platinum", "Gold", "Mercury", "Thallium", "Lead", "Bismuth", "Polonium", "Astatine", "Radon", "Francium", "Radium", "Actinium", "Thorium", "Protactinium", "Uranium", "Neptunium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Mendelevium", "Nobelium", "Lawrencium", "Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium", "Darmstadtium", "Roentgenium", "Copernicium", "Nihonium", "Flerovium", "Moscovium", "Livermorium", "Tennessine", "Oganesson"]
    
    var elementGroups = [1, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    // http://periodictable.com/Properties/A/ElectronConfigurationString.an.html
    var electronConfigs = ["1s1", "1s2", "[He]2s1", "[He]2s2", "[He]2s22p1", "[He]2s22p2", "[He]2s22p3", "[He]2s22p4", "[He]2s22p5", "[He]2s22p6", "[Ne]3s1", "[Ne]3s2", "[Ne]3s23p1", "[Ne]3s23p2", "[Ne]3s23p3", "[Ne]3s23p4", "[Ne]3s23p5", "[Ne]3s23p6", "[Ar]4s1", "[Ar]4s2", "[Ar]4s23d1", "[Ar]4s23d2", "[Ar]4s23d3", "[Ar]4s13d5", "[Ar]4s23d5", "[Ar]4s23d6", "[Ar]4s23d7", "[Ar]4s23d8", "[Ar]4s13d10", "[Ar]4s23d10", "[Ar]4s23d104p1", "[Ar]4s23d104p2", "[Ar]4s23d104p3", "[Ar]4s23d104p4", "[Ar]4s23d104p5", "[Ar]4s23d104p6", "[Kr]5s1", "[Kr]5s2", "[Kr]5s24d1", "[Kr]5s24d2", "[Kr]5s14d4", "[Kr]5s14d5", "[Kr]5s24d5", "[Kr]5s14d7", "[Kr]5s14d8", "[Kr]4d10", "[Kr]5s14d10", "[Kr]5s24d10", "[Kr]5s24d105p1", "[Kr]5s24d105p2", "[Kr]5s24d105p3", "[Kr]5s24d105p4", "[Kr]5s24d105p5", "[Kr]5s24d105p6", "[Xe]6s1", "[Xe]6s2", "[Xe]6s25d1", "[Xe]6s24f15d1", "[Xe]6s24f3", "[Xe]6s24f4", "[Xe]6s24f5", "[Xe]6s24f6", "[Xe]6s24f7", "[Xe]6s24f75d1", "[Xe]6s24f9", "[Xe]6s24f10", "[Xe]6s24f11", "[Xe]6s24f12", "[Xe]6s24f13", "[Xe]6s24f14", "[Xe]6s24f145d1", "[Xe]6s24f145d2", "[Xe]6s24f145d3", "[Xe]6s24f145d4", "[Xe]6s24f145d5", "[Xe]6s24f145d6", "[Xe]6s24f145d7", "[Xe]6s14f145d9", "[Xe]6s14f145d10", "[Xe]6s24f145d10", "[Xe]6s24f145d106p1", "[Xe]6s24f145d106p2", "[Xe]6s24f145d106p3", "[Xe]6s24f145d106p4", "[Xe]6s24f145d106p5", "[Xe]6s24f145d106p6", "[Rn]7s1", "[Rn]7s2", "[Rn]7s26d1", "[Rn]7s26d2", "[Rn]7s25f26d1", "[Rn]7s25f36d1", "[Rn]7s25f46d1", "[Rn]7s25f6", "[Rn]7s25f7", "[Rn]7s25f76d1", "[Rn]7s25f9", "[Rn]7s25f10", "[Rn]7s25f11", "[Rn]7s25f12", "[Rn]7s25f13", "[Rn]7s25f14", "[Rn]7s25f147p1", "[Rn]7s25f146d2", "[Rn]7s25f146d3", "[Rn]7s25f146d4", "[Rn]7s25f146d5", "[Rn]7s25f146d6", "[Rn]7s25f146d7", "[Rn]7s15f146d9", "[Rn]7s15f146d10", "[Rn]7s25f146d10", "[Rn]7s25f146d107p1", "[Rn]7s25f146d107p2", "[Rn]7s25f146d107p3", "[Rn]7s25f146d107p4", "[Rn]7s25f146d107p5", "[Rn]7s25f146d107p6"]
    
    // http://www.elementalmatter.info/number-of-neutrons.htm
    var neutrons = ["0", "2", "4", "5", "6", "6", "7", "8", "10", "10", "12", "12", "14", "14", "16", "16", "18", "22", "21", "20", "24", "26", "28", "28", "30", "30", "31", "30", "35", "35", "39", "41", "42", "45", "45", "48", "48", "50", "50", "51", "52", "54", "55", "57", "58", "60", "61", "64", "66", "69", "71", "76", "74", "77", "78", "81", "82", "82", "82", "84", "84", "88", "89", "93", "94", "97", "98", "99", "100", "103", "104", "106", "108", "110", "111", "114", "115", "117", "118", "121", "123", "125", "126", "125", "125", "136", "136", "138", "138", "142", "140", "146", "144", "150", "148", "151", "150", "153", "153", "157", "157", "157", "159", "157", "N/A", "157", "157", "161", "159", "162", "162", "165", "173", "175", "173", "176", "175", "175"]
    
    @IBOutlet weak var table: UITableView!
    var cell: ElementTableViewCell?
    
    var elementCellInfo = [Int:[String]]()
    var filteredElements = [Int:[String]]()
    var searchController: UISearchController!
    var keys = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Enter element or atomic number"
            UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        } else {
            // Fallback on earlier versions
        }
        
        // Element data from: https://github.com/andrejewski/periodic-table
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Elements").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let element = ElementInfoObject(dictionary: dictionary)
                elements.append(element)
            }
        })
        
        // setup dictionary
        var i = 0
        for elementName in elementNames {
            // 0
            elementCellInfo[i] = [elementName]
            i = i + 1
        }
        
        i = 0
        for symbol in elementSymbols {
            // 1
            elementCellInfo[i]?.append(symbol)
            i = i + 1
        }
        
        i = 0
        for mass in atomicMasses {
            // 2
            elementCellInfo[i]?.append(String(mass))
            i = i + 1
        }
        
        i = 0
        for atomicNumber in 1...118 {
            // 3
            elementCellInfo[i]?.append(String(atomicNumber))
            i = i + 1
        }
        
        i = 0
        for config in electronConfigs {
            // 4
            elementCellInfo[i]?.append(config)
            i = i + 1
        }
        
        i = 0
        for group in elementGroups {
            // 5
            elementCellInfo[i]?.append(String(group))
            i = i + 1
        }
        
        i = 0
        for neutron in neutrons {
            // 6
            elementCellInfo[i]?.append(neutron)
            i = i + 1
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    /* TABLE VIEW */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredElements.count
        }
        
        return elementNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as? ElementTableViewCell
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ElementInfoViewController") as! ElementInfoViewController
        if isFiltering() {
            vc.databaseIndex = keys[indexPath.row]
        } else {
            vc.databaseIndex = indexPath.row
        }
        navigationController?.pushViewController(vc, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ElementTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        keys = Array(filteredElements.keys)
        
        if isFiltering() {
            // element box
            cell?.elementName.text = filteredElements[keys[indexPath.row]]?[0]
            cell?.symbol.text = filteredElements[keys[indexPath.row]]?[1]
            cell?.massNumber2.text = filteredElements[keys[indexPath.row]]?[2]
            cell?.atomicNumber2.text = filteredElements[keys[indexPath.row]]?[3]
            
            // groups
            cell?.groupName.text = "Group: " + (filteredElements[keys[indexPath.row]]?[5])!
            
            // protons/neutrons
            cell?.atomicNumber.text = "Protons/neutrons: " + (filteredElements[keys[indexPath.row]]?[3])! + "/" + (filteredElements[keys[indexPath.row]]?[6])!
            
            // electron configuration
            let formatter = TextFormatter()
            if (indexPath.row > 29) {
                let mutableAttributedString = NSMutableAttributedString(string: "Config: ", attributes: nil)
                let electronConfig = formatter.fixElectron(config: (filteredElements[keys[indexPath.row]]?[4])!, font: "SMALL")
                
                let cellText = NSMutableAttributedString()
                cellText.append(mutableAttributedString)
                cellText.append(electronConfig)
                
                cell?.massNumber.attributedText = cellText
                
            } else {
                let mutableAttributedString = NSMutableAttributedString(string: "Electron config: ", attributes: nil)
                let electronConfig = formatter.fixElectron(config: (filteredElements[keys[indexPath.row]]?[4])!, font: "SMALL")
                
                let cellText = NSMutableAttributedString()
                cellText.append(mutableAttributedString)
                cellText.append(electronConfig)
                
                cell?.massNumber.attributedText = cellText
            }
        } else {
            // element box
            cell?.elementName.text = elementCellInfo[indexPath.row]?[0]
            cell?.symbol.text = elementCellInfo[indexPath.row]?[1]
            cell?.massNumber2.text = elementCellInfo[indexPath.row]?[2]
            cell?.atomicNumber2.text = elementCellInfo[indexPath.row]?[3]
            
            // groups
            cell?.groupName.text = "Group: " + (elementCellInfo[indexPath.row]?[5])!
            
            // protons/neutrons
            cell?.atomicNumber.text = "Protons/neutrons: " + (elementCellInfo[indexPath.row]?[3])! + "/" + (elementCellInfo[indexPath.row]?[6])!
            
            // electron configuration
            let formatter = TextFormatter()
            if (indexPath.row > 29) {
                let mutableAttributedString = NSMutableAttributedString(string: "Config: ", attributes: nil)
                let electronConfig = formatter.fixElectron(config: (elementCellInfo[indexPath.row]?[4])!, font: "SMALL")
                
                let cellText = NSMutableAttributedString()
                cellText.append(mutableAttributedString)
                cellText.append(electronConfig)
                
                cell?.massNumber.attributedText = cellText
                
            } else {
                let mutableAttributedString = NSMutableAttributedString(string: "Electron config: ", attributes: nil)
                let electronConfig = formatter.fixElectron(config: (elementCellInfo[indexPath.row]?[4])!, font: "SMALL")
                
                let cellText = NSMutableAttributedString()
                cellText.append(mutableAttributedString)
                cellText.append(electronConfig)
                
                cell?.massNumber.attributedText = cellText
            }
        }
        
        
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
}

extension ElementsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() == false {
            let searchText = searchController.searchBar.text!
            if uppercase.contains(String(searchText[0])) {
                // search by element name
                filteredElements = elementCellInfo.filter({$0.value[0].range(of: searchText) != nil})
            } else if lowercase.contains(String(searchText[0])) {
                filteredElements = elementCellInfo.filter({$0.value[0].lowercased().range(of: searchText) != nil})
            } else if decimal.contains(String(searchText[0])) {
                // search by atomic number
                if searchText.count == 1 {
                    filteredElements = elementCellInfo.filter({$0.value[3].range(of: searchText) != nil})
                    for filteredElement in filteredElements {
                        if filteredElement.value[3].count > 1 {
                            filteredElements[filteredElement.key] = nil
                        }
                    }
                } else if searchText.count == 2 {
                    filteredElements = elementCellInfo.filter({$0.value[3].prefix(2).range(of: searchText) != nil})
                } else {
                    filteredElements = elementCellInfo.filter({$0.value[3].range(of: searchText) != nil})
                }
            }
        }
        
        table.reloadData()
    }
}

class ElementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var atomicNumber: UILabel!
    @IBOutlet weak var massNumber: UILabel!
    @IBOutlet weak var symbolBackground: UIView!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var elementName: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var atomicNumber2: UILabel!
    @IBOutlet weak var massNumber2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

