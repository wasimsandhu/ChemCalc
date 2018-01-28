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
    let polyatomicIons = [["Nitrate ion: NH4+", "Hydronium ion: H3O+"], ["Mercury (I) ion: Hg22+"], ["Nitrite ion: NO2-", "Nitrate ion: NO3-", "Hydrogen sulfate ion: HSO4-", "Dihydrogen phosphate ion: H2PO4-", "Hydroxide ion: OH-", "Acetate ion: C2H3O2-", "Perchlorate ion: ClO4-", "Chlorate ion: ClO3-", "Chlorite ion: ClO2-", "Hypochlorite ion: ClO-", "Permanganate ion: MnO4-", "Cyanide ion: CN-", "Cyanate ion: CNO-", "Thiocyanate ion: SCN-", "Hydrogen carbonate ion: HCO3-"], ["Sulfate ion: SO42-", "Sulfite ion: SO32-", "Hydrogen phosphate ion: HPO42-", "Peroxide ion: O22-", "Chromate ion: CrO42-", "Dichromate ion: Cr2O72-", "Carbonate ion: CO32-", "Oxalate ion: C2O42-", "Thiosulfate ion: S2O32-"], ["Phosphate ion: PO43-", "Phosphite ion: PO33-", "Borate ion: BO33-"]]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "polycell", for: indexPath)
        let formatter = TextFormatter()
        let formattedFormula = formatter.fix(formula: polyatomicIons[indexPath.section][indexPath.row])
        cell.textLabel?.attributedText = formattedFormula
        return cell
    }
}
