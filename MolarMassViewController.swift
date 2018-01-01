//
//  ViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/4/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MolarMassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var compoundName: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var molarMassTable: UITableView!
    var cell: MolarMassCell?
    
    var input: String?
    
    var dictionary: [String:Double] = [:]
    var molarMass: Double?
    var elements = [String]()
    var quantities = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input = self.textField.text
        textField.resignFirstResponder()
        getMolarMass()
        return true
    }
    
    func getMolarMass() {
        
        let molarMassCalc = MolarMassCalculator()
        
        dictionary = molarMassCalc.createDictionary()
        molarMass = molarMassCalc.calculate(compound: input!)
        elements = molarMassCalc.getElementsInCompound()
        quantities = molarMassCalc.getNumberOfElements()
        
        // get compound name
        // TODO: move this snippet to model class
        var handle = FIRDatabase.database().reference().child("Compounds").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let compound_name = value[self.input] as? String ?? ""
                self.compoundName.text = compound_name
            }
        })
        
        molarMassTable.reloadData()
    }
    
    /* TABLE VIEW */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = molarMassTable.dequeueReusableCell(withIdentifier: "mmcell", for: indexPath) as? MolarMassCell
        
        if (indexPath.row == 0) {
            cell?.categoryLabel?.text = "Molar Mass"
            if (molarMass != nil) {
                cell?.valueLabel?.text =  String(describing: molarMass!)
            } else {
                cell?.valueLabel?.text = " "
            }
        } else {
            let elementForCell = elements[indexPath.row - 1]
            let numberForCell = quantities[indexPath.row - 1]
            
            let massPercent = ((dictionary[elementForCell]! * Double(numberForCell)) / molarMass!) * 100
            let massPercentRounded = Double(round(1000 * massPercent) / 1000)
            
            cell?.categoryLabel?.text = elementForCell + " × " + String(numberForCell)
            cell?.valueLabel?.text = String(describing: massPercentRounded) + "%"
        }

        return cell!
    }

}

