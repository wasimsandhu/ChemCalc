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

    // tabs
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var converterView: UIView!
    
    // calculator view elements
    @IBOutlet weak var compoundName: UILabel!
    @IBOutlet weak var molarTextField: UITextField!
    @IBOutlet weak var molarMassTable: UITableView!
    var cell: MolarMassCell?
    
    // converter view elements
    @IBOutlet weak var molarTextField2: UITextField!
    @IBOutlet weak var isEqualToLabel: UILabel!
    @IBOutlet weak var gramsTextField: UITextField!
    @IBOutlet weak var molesTextField: UITextField!
    
    // converter variables
    var input: String?
    var gramsInput: String?
    var molesInput: String?
    
    // calculator variables
    var dictionary: [String:Double] = [:]
    var molarMass: Double?
    var elements = [String]()
    var quantities = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        molarTextField.delegate = self
        gramsTextField.delegate = self
        molesTextField.delegate = self
        molarTextField2.delegate = self
        
        converterView.isHidden = true
        calculatorView.isHidden = false
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            converterView.isHidden = true
            calculatorView.isHidden = false
            molarTextField.becomeFirstResponder()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            calculatorView.isHidden = true
            converterView.isHidden = false
            molarTextField2.becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == molarTextField {
            input = self.molarTextField.text
            getMolarMass()
            molesToGrams(input: "1")
            molarTextField2.text = input!
            
        }
        
        if textField == molarTextField2 {
            input = self.molarTextField2.text
            getMolarMass()
            molesToGrams(input: "1")
            molarTextField.text = input!
        }
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
                
                if compound_name == "" {
                    let nameAndFormula = TextFormatter().fix(formula: self.input!)
                    self.compoundName.attributedText = nameAndFormula
                } else {
                    let nameAndFormula = TextFormatter().fix(formula: compound_name + ": " + self.input!)
                    self.compoundName.attributedText = nameAndFormula
                }
            }
        })
        
        isEqualToLabel.attributedText = TextFormatter().fix(formula: "of " + input! + " is equal to")
        
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
                cell?.valueLabel?.text =  String(describing: molarMass!) + " grams"
            } else {
                cell?.valueLabel?.text = " "
            }
        } else {
            if molarMass != nil && dictionary[elements[indexPath.row - 1]] != nil {
                let elementForCell = elements[indexPath.row - 1]
                let numberForCell = quantities[indexPath.row - 1]
                
                let massPercent = ((dictionary[elementForCell]! * Double(numberForCell)) / molarMass!) * 100
                let massPercentRounded = Double(round(1000 * massPercent) / 1000)
                
                cell?.categoryLabel?.text = elementForCell + " × " + String(numberForCell)
                cell?.valueLabel?.text = String(describing: massPercentRounded) + "%"
            } else {
                cell?.categoryLabel?.text = ""
                cell?.valueLabel?.text = ""
            }
            
        }

        return cell!
    }
    
    @IBAction func loadLearnView(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LearnViewController") as! LearnViewController
        vc.pageTitle = "Molar Mass"
        vc.fileName = "molarmass"
        navigationController?.pushViewController(vc, animated: true)
    }
}

class MolarMassCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
