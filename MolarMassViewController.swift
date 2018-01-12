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
    @IBOutlet weak var molarTextField: UITextField!
    @IBOutlet weak var molarMassTable: UITableView!
    var cell: MolarMassCell?
    
    @IBOutlet weak var isEqualToLabel: UILabel!
    @IBOutlet weak var gramsTextField: UITextField!
    @IBOutlet weak var molesTextField: UITextField!
        
    var input: String?
    var gramsInput: String?
    var molesInput: String?
    
    var dictionary: [String:Double] = [:]
    var molarMass: Double?
    var elements = [String]()
    var quantities = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        molarTextField.delegate = self
        gramsTextField.delegate = self
        molesTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == molarTextField {
            molarTextField.text = ""
        } else if textField == gramsTextField {
            gramsTextField.text = ""
        } else if textField == molesTextField {
            molesTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input = self.molarTextField.text
        
        if textField == molarTextField {
            molarTextField.resignFirstResponder()
            getMolarMass()
        } else if textField == gramsTextField {
            gramsInput = self.gramsTextField.text
            gramsTextField.resignFirstResponder()
            gramsToMoles()
        } else if textField == molesTextField {
            molesInput = self.molesTextField.text
            molesTextField.resignFirstResponder()
            molesToGrams()
        }

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
                let nameAndFormula = TextFormatter().fix(formula: compound_name + " (" + self.input! + ")")
                self.compoundName.attributedText = nameAndFormula
            }
        })
        
        isEqualToLabel.text = "of " + input! + " is equal to"
        
        molarMassTable.reloadData()
    }
    
    // TODO: move these functions to model class
    func gramsToMoles() {
        if let grams = Double(gramsInput!) {
            let amountInMoles = grams / molarMass!
            let amountInMolesRounded = Double(round(1000 * amountInMoles) / 1000)
            gramsTextField.text = gramsInput! + " grams"
            molesTextField.text = String(amountInMolesRounded) + " moles"
        }
    }
    
    func molesToGrams() {
        if let moles = Double(molesInput!) {
            let amountInGrams = moles * molarMass!
            gramsTextField.text = String(amountInGrams) + " grams"
            molesTextField.text = molesInput! + " moles"
        }
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

