//
//  EquationsViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class StoichiometryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // tabs
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var stoichiometryView: UIView!
    
    // table views
    @IBOutlet weak var balanceTableView: UITableView!
    @IBOutlet weak var stoichTableView: UITableView!
    
    // text fields
    @IBOutlet weak var balanceTextField: UITextField!
    
    @IBOutlet weak var firstReactantTextField: UITextField!
    @IBOutlet weak var secondReactantTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    
    @IBOutlet weak var firstAmountTextField: UITextField!
    @IBOutlet weak var secondAmountTextField: UITextField!
    
    @IBOutlet weak var firstCoefficientTextField: UITextField!
    @IBOutlet weak var secondCoefficientTextField: UITextField!
    @IBOutlet weak var productCoefficientTextField: UITextField!
    
    // stoichiometry values
    var firstReactant: String?
    var secondReactant: String?
    var product: String?
    var firstAmount: Double?
    var secondAmount: Double?
    var firstCoefficient: Int?
    var secondCoefficient: Int?
    var productCoefficient: Int?
    
    var limitingReactant: String?
    var excessReactantLeft: Double?
    var theoreticalYield: Double?
    
    var stoichCalc: Stoichiometry!
    var textIsAcceptable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        stoichCalc = Stoichiometry()
        
        stoichiometryView.isHidden = true
        balanceView.isHidden = false
        
        firstReactantTextField.delegate = self
        secondReactantTextField.delegate = self
        productTextField.delegate = self
        firstAmountTextField.delegate = self
        secondAmountTextField.delegate = self
        firstCoefficientTextField.delegate = self
        secondCoefficientTextField.delegate = self
        productCoefficientTextField.delegate = self
        
        tabs.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    // segmented control tabs
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if tabs.selectedSegmentIndex == 0 {
            stoichiometryView.isHidden = true
            balanceView.isHidden = false
            firstReactantTextField.resignFirstResponder()
        } else if tabs.selectedSegmentIndex == 1 {
            balanceView.isHidden = true
            stoichiometryView.isHidden = false
            firstReactantTextField.becomeFirstResponder()
        }
    }
    
    // text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstReactantTextField {
            self.firstReactantTextField.text! = (firstReactantTextField.text?.replacingOccurrences(of: " ", with: ""))!
            firstReactant = self.firstReactantTextField.text
            firstReactantTextField.resignFirstResponder()
            firstAmountTextField.becomeFirstResponder()
        } else if textField == firstAmountTextField {
            self.firstAmountTextField.text! = (firstAmountTextField.text?.replacingOccurrences(of: " ", with: ""))!
            firstAmount = Double(self.firstAmountTextField.text!)
            self.firstAmountTextField.text! += " g"
            firstAmountTextField.resignFirstResponder()
            firstCoefficientTextField.becomeFirstResponder()
        } else if textField == firstCoefficientTextField {
            self.firstCoefficientTextField.text! = (firstCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            firstCoefficient = Int(self.firstCoefficientTextField.text!)
            firstCoefficientTextField.resignFirstResponder()
            secondReactantTextField.becomeFirstResponder()
        } else if textField == secondReactantTextField {
            self.secondReactantTextField.text! = (secondReactantTextField.text?.replacingOccurrences(of: " ", with: ""))!
            secondReactant = self.secondReactantTextField.text
            secondReactantTextField.resignFirstResponder()
            secondAmountTextField.becomeFirstResponder()
        } else if textField == secondAmountTextField {
            self.secondAmountTextField.text! = (secondAmountTextField.text?.replacingOccurrences(of: " ", with: ""))!
            secondAmount = Double(self.secondAmountTextField.text!)
            secondAmountTextField.resignFirstResponder()
            self.secondAmountTextField.text! += " g"
            secondCoefficientTextField.becomeFirstResponder()
        } else if textField == secondCoefficientTextField {
            self.secondCoefficientTextField.text! = (secondCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            secondCoefficient = Int(self.secondCoefficientTextField.text!)
            secondCoefficientTextField.resignFirstResponder()
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                
                excessReactantLeft = stoichCalc.getExcessReactant()
                theoreticalYield = nil
                
                stoichTableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "One or more text fields were not completed. Please check that your compound formula, reactant amount, and coefficient from the balanced chemical equation have been inputted correctly.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else if textField == productTextField {
            self.productTextField.text! = (productTextField.text?.replacingOccurrences(of: " ", with: ""))!
            product = self.productTextField.text
            productTextField.resignFirstResponder()
            productCoefficientTextField.becomeFirstResponder()
        } else if textField == productCoefficientTextField {
            self.productCoefficientTextField.text! = (productCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            productCoefficient = Int(self.productCoefficientTextField.text!)
            productCoefficientTextField.resignFirstResponder()
            
            theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
            
            stoichTableView.reloadData()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Find out what the text field will be after adding the current edit
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == firstCoefficientTextField || textField == secondCoefficientTextField || textField == productCoefficientTextField {
            if let val = Int(text) {
                textIsAcceptable = true
            } else {
                textIsAcceptable = false
            }
        } else if textField == firstAmountTextField || textField == secondAmountTextField {
            
        }
        
        return true
    }
    
    func textFieldIsNil() -> Bool {
        if firstReactant == nil || firstReactant == "" || firstAmount == nil || firstCoefficient == nil || secondReactant == nil || secondReactant == "" || secondAmount == nil || secondCoefficient == nil || theoreticalYield == nil || excessReactantLeft == nil || limitingReactant == nil {
            return true
        } else {
            return false
        }
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == balanceTableView {
            return 4
        } else if tableView == stoichTableView {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stoichcell") as? StoichCell
        
        if tableView == balanceTableView {
            
        } else if tableView == stoichTableView {
            if indexPath.row == 0 {
                cell?.keyLabel.text = "Limiting Reactant"
                if limitingReactant == nil {
                    cell?.valueLabel.text = ""
                } else {
                    cell?.valueLabel.attributedText = TextFormatter().fix(formula: limitingReactant!)
                }
            } else if indexPath.row == 1 {
                cell?.keyLabel.text = "Excess Reactant Left"
                if excessReactantLeft == nil {
                    cell?.valueLabel.text = ""
                } else {
                    cell?.valueLabel.text = String(describing: Double(round(1000 * excessReactantLeft!) / 1000)) + " g"
                }
            } else if indexPath.row == 2 {
                cell?.keyLabel.text = "Theoretical Yield"
                if theoreticalYield == nil {
                    cell?.valueLabel.text = ""
                } else {
                    cell?.valueLabel.text = String(describing: Double(round(1000 * theoreticalYield!) / 1000)) + " g"
                }
            }
        }
        
        return cell!
    }
    
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
