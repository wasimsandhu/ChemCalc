//
//  ElementsViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class ElementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cell: ElementTableViewCell?
    
    var elementSymbols = ["H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Uub", "Uut", "Uuq", "Uup", "Uuh", "Uus", "Uuo"];

    var elementNames = ["Hydrogen", "Helium", "Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon", "Sodium", "Magnesium", "Aluminum", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium", "Tin", "Antimony", "Tellurium", "Iodine", "Xenon", "Cesium", "Barium", "Lanthanum", "Cerium", "Praseodymium", "Neodymium", "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium", "Hafnium", "Tantalum", "Tungsten", "Rhenium", "Osmium", "Iridium", "Platinum", "Gold", "Mercury", "Thallium", "Lead", "Bismuth", "Polonium", "Astatine", "Radon", "Francium", "Radium", "Actinium", "Thorium", "Protactinium", "Uranium", "Neptunium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Mendelevium", "Nobelium", "Lawrencium", "Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium", "Darmstadtium", "Roentgenium", "Ununbium", "Ununtrium", "Ununquadium", "Ununpentium", "Ununhexium", "Ununseptium", "Ununoctium"]
    
    var elementGroups = [1, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    var atomicMasses = [1.0079, 4.0026, 6.941, 9.0122, 10.811, 12.0107, 14.0067, 15.9994, 18.9984, 20.1797, 22.9897, 24.305, 26.9815, 28.0855, 30.9738, 32.065, 35.453, 39.948, 39.0983, 40.078, 44.9559, 47.867, 50.9415, 51.9961, 54.938, 55.845, 58.9332, 58.6934, 63.546, 65.39, 69.723, 72.64, 74.9216, 78.96, 79.904, 83.8, 85.4678, 87.62, 88.9059, 91.224, 92.9064, 95.94, 98, 101.07, 102.9055, 106.42, 107.8682, 112.411, 114.818, 118.71, 121.76, 126.9045, 127.6, 131.293, 132.9055, 137.327, 138.9055, 140.116, 140.9077, 144.24, 144.913, 150.36, 151.964, 157.25, 158.9253, 162.5, 164.9303, 167.259, 168.9342, 173.04, 174.967, 178.49, 180.9479, 183.84, 186.207, 190.23, 192.217, 195.078, 196.9665, 200.59, 204.3833, 207.2, 208.9804, 208.982, 209.987, 222.018, 223.0197, 226.0254, 227.028, 232.038, 231.036, 238.029, 237.048, 244.0642, 243.0614, 247.070, 247.070, 251.0796, 254, 257.095, 258.1, 259.101, 262, 261, 262, 266, 264, 269, 268, 269, 272, 277, 0, 289, 0, 298, 0, 0]
    
    var colors = ["F44336", "E91E63", "3F51B5", "9C27B0", "673AB7", "2196F3", "03A9F4", "00BCD4", "009688", "4CAF50", "1B5E20", "FBC02D", "FFC107", "FF9800", "EF6C00", "FF5722"]
    
    var elementSymbolDict: [String:String] = [:]
    var symbolMassDict: [String:Double] = [:]
    var elementGroupDict: [String:Int] = [:]
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // merge arrays into dictionaries
        // https://stackoverflow.com/questions/32140969/how-can-i-merge-two-arrays-into-a-dictionary
        for (a, b) in elementNames.enumerated() {
            elementSymbolDict[b] = elementSymbols[a]
        }
        
        for (a, b) in elementSymbols.enumerated() {
            symbolMassDict[b] = atomicMasses[a]
        }
        
        for (a, b) in elementNames.enumerated() {
            elementGroupDict[b] = elementGroups[a]
        }
        
        print(elementSymbolDict)
        print(symbolMassDict)
        print(elementGroupDict)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* TABLE VIEW */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ElementTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        cell?.elementName.text = elementNames[indexPath.row]
        cell?.symbol.text = elementSymbols[indexPath.row]
        cell?.symbolBackground?.backgroundColor = UIColor(hex: colors[indexPath.row % colors.count])
        cell?.atomicNumber.text = "Atomic Number (Z): " + String(indexPath.row + 1)
        cell?.atomicNumber2.text = String(indexPath.row + 1)
        cell?.massNumber.text = "Molar Mass (A): " + String(atomicMasses[indexPath.row]) + " g"
        cell?.massNumber2.text = String(atomicMasses[indexPath.row])
        cell?.groupName.text = "Group: " + String(elementGroups[indexPath.row])
        
        return cell!
    }
}

// http://crunchybagel.com/working-with-hex-colors-in-swift-3/
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
