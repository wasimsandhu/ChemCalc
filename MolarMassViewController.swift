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

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var converterView: UIView!
    
    @IBOutlet weak var compoundName: UILabel!
    @IBOutlet weak var molarTextField: UITextField!
    @IBOutlet weak var molarMassTable: UITableView!
    var cell: MolarMassCell?
    
    @IBOutlet weak var molarTextField2: UITextField!
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
        molarTextField2.delegate = self
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            converterView.isHidden = true
            calculatorView.isHidden = false
        } else if segmentedControl.selectedSegmentIndex == 1 {
            calculatorView.isHidden = true
            converterView.isHidden = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == molarTextField {
            input = self.molarTextField.text
            molarTextField.resignFirstResponder()
            getMolarMass()
            molesToGrams(input: "1")
            molarTextField2.text = input!
            
        } else if textField == gramsTextField {
            gramsInput = self.gramsTextField.text
            gramsTextField.resignFirstResponder()
            gramsToMoles(input: gramsInput!)
            
        } else if textField == molesTextField {
            molesInput = self.molesTextField.text
            molesTextField.resignFirstResponder()
            molesToGrams(input: molesInput!)
            
        } else if textField == molarTextField2 {
            input = self.molarTextField2.text
            molarTextField2.resignFirstResponder()
            getMolarMass()
            molesToGrams(input: "1")
            molarTextField.text = input!
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
    func gramsToMoles(input: String) {
        if let grams = Double(input) {
            let amountInMoles = grams / molarMass!
            let amountInMolesRounded = Double(round(1000 * amountInMoles) / 1000)
            gramsTextField.text = input + " grams"
            molesTextField.text = String(amountInMolesRounded) + " moles"
        }
    }
    
    func molesToGrams(input: String) {
        if let moles = Double(input) {
            let amountInGrams = moles * molarMass!
            gramsTextField.text = String(amountInGrams) + " grams"
            molesTextField.text = input + " moles"
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

