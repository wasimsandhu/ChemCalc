//
//  PolyatomicVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/26/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class PolyatomicVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let charges = ["Charge: +1", "Charge: +2", "Charge: -1", "Charge: -2", "Charge: -3"]
    let polyatomicIonNames = [["Ammonium ion", "Hydronium ion"], ["Mercury (I) ion"], ["Nitrite ion", "Nitrate ion", "Hydrogen sulfate ion", "Dihydrogen phosphate ion", "Hydroxide ion", "Acetate ion", "Perchlorate ion", "Chlorate ion", "Chlorite ion", "Hypochlorite ion", "Permanganate ion", "Cyanide ion", "Cyanate ion", "Thiocyanate ion", "Hydrogen carbonate ion"], ["Sulfate ion", "Sulfite ion", "Hydrogen phosphate ion", "Peroxide ion", "Chromate ion", "Dichromate ion", "Carbonate ion", "Oxalate ion", "Thiosulfate ion"], ["Phosphate ion", "Phosphite ion", "Borate ion"]]
    let polyatomicIons = [["NH4+", "H3O+"], ["Hg22+"], ["NO2-", "NO3-", "HSO4-", "H2PO4-", "OH-", "C2H3O2-", "ClO4-", "ClO3-", "ClO2-", "ClO-", "MnO4-", "CN-", "CNO-", "SCN-", "HCO3-"], ["SO42-", "SO32-", "HPO42-", "O22-", "CrO42-", "Cr2O72-", "CO32-", "C2O42-", "S2O32-"], ["PO43-", "PO33-", "BO33-"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return charges.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return charges[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polyatomicIons[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "polycell", for: indexPath) as! PolyCell
        let formatter = TextFormatter()
        let formattedFormula = formatter.fix(formula: polyatomicIons[indexPath.section][indexPath.row])
        cell.nameLabel?.text = polyatomicIonNames[indexPath.section][indexPath.row]
        cell.formulaLabel?.attributedText = formattedFormula
        return cell
    }
}

class PolyCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
