//
//  EnthalpyVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 4/5/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EnthalpyVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var reactionTextField: UITextField!
    @IBOutlet weak var balancedEquationText: UILabel!
    @IBOutlet weak var enthalpyLabel: UILabel!
    @IBOutlet weak var yeeet: UILabel!
    
    @IBOutlet weak var coefficient6TextField: UITextField!
    @IBOutlet weak var coefficient5TextField: UITextField!
    @IBOutlet weak var coefficient4TextField: UITextField!
    @IBOutlet weak var coefficient3TextField: UITextField!
    @IBOutlet weak var coefficient2TextField: UITextField!
    @IBOutlet weak var coefficient1TextField: UITextField!
    
    @IBOutlet weak var compound1TextField: UITextField!
    @IBOutlet weak var compound2TextField: UITextField!
    @IBOutlet weak var compound3TextField: UITextField!
    @IBOutlet weak var compound4TextField: UITextField!
    @IBOutlet weak var compound5TextField: UITextField!
    @IBOutlet weak var compound6TextField: UITextField!
    
    @IBOutlet weak var enthalpy1TextField: UITextField!
    @IBOutlet weak var enthalpy2TextField: UITextField!
    @IBOutlet weak var enthalpy3TextField: UITextField!
    @IBOutlet weak var enthalpy4TextField: UITextField!
    @IBOutlet weak var enthalpy5TextField: UITextField!
    @IBOutlet weak var enthalpy6TextField: UITextField!
        
    var coefficients = [Int]()
    var compounds = [String]()
    var numberOfTextFields: Int!
    var reactants: Int!
    var products: Int!
    var betterCompoundDictionary = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        yeeet.isHidden = true
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Thermodynamics").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let compound = ThermoDataObject(dictionary: dictionary)
                self.betterCompoundDictionary[compound.name!] = compound.enthalpy
            }
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == reactionTextField {
            clearText()
            reactionTextField.resignFirstResponder()
            let equationWithStates = reactionTextField.text
            getBalancedEquation(inputBoi: equationWithStates!)
        } else {
            editText()
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == reactionTextField {
            clearText()
            reactionTextField.resignFirstResponder()
            let equationWithStates = reactionTextField.text
            getBalancedEquation(inputBoi: equationWithStates!)
            yeeet.isHidden = false
        } else {
            editText()
            textField.resignFirstResponder()
        }
        return true
    }
    
    func getBalancedEquation(inputBoi: String) {
        if (reactionTextField.text?.contains("+"))! && (reactionTextField.text?.contains("="))! {
            let balancer = ChemicalEquationBalancer()
            coefficients = balancer.setupMatrix(input: inputBoi)
            compounds = balancer.getCompounds()
            let formatter = TextFormatter()
            
            var completeEquation = NSMutableAttributedString()
            var coefficient: NSMutableAttributedString!
            let plus = NSMutableAttributedString(string: " + ", attributes: nil)
            let equals = NSMutableAttributedString(string: " → ", attributes: nil)
            let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
            
            reactants = balancer.getReactants().count
            products = balancer.getProducts().count
            
            if reactants == 2 && products == 2 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[3]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[3]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 3 && products == 3 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[3]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[3]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[4]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[4]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[5]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[5]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 1 && products == 1 {
                
            } else if reactants == 2 && products == 1 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 1 && products == 2 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 2 && products == 3 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[3]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[3]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[4]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[4]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 3 && products == 2 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[3]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[3]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[4]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[4]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else if reactants == 3 && products == 3 {
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[2]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[2]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[3]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[3]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[4]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[4]))
                completeEquation.append(plus)
                coefficient = NSMutableAttributedString(string: String(coefficients[5]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[5]))
                
                balancedEquationText.attributedText = completeEquation
                
            } else {
                let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
                reactionTextField.resignFirstResponder()
            }
        } else {
            let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
            reactionTextField.resignFirstResponder()
        }
        
        fillTextFields()
    }
    
    func fillTextFields() {
        numberOfTextFields = coefficients.count
        
        if numberOfTextFields == 3 {
            
            coefficient1TextField.isHidden = false
            coefficient2TextField.isHidden = false
            coefficient3TextField.isHidden = false
            coefficient4TextField.isHidden = true
            coefficient5TextField.isHidden = true
            coefficient6TextField.isHidden = true
            
            compound1TextField.isHidden = false
            compound2TextField.isHidden = false
            compound3TextField.isHidden = false
            compound4TextField.isHidden = true
            compound5TextField.isHidden = true
            compound6TextField.isHidden = true
            
            enthalpy1TextField.isHidden = false
            enthalpy2TextField.isHidden = false
            enthalpy3TextField.isHidden = false
            enthalpy4TextField.isHidden = true
            enthalpy5TextField.isHidden = true
            enthalpy6TextField.isHidden = true
            
            coefficient1TextField.text = String(coefficients[0])
            coefficient2TextField.text = String(coefficients[1])
            coefficient3TextField.text = String(coefficients[2])
            
            compound1TextField.text = String(compounds[0])
            compound2TextField.text = String(compounds[1])
            compound3TextField.text = String(compounds[2])
            
            if betterCompoundDictionary[compound1TextField.text!] != nil {
                enthalpy1TextField.text = betterCompoundDictionary[compound1TextField.text!]
            }
            
            if betterCompoundDictionary[compound2TextField.text!] != nil {
                enthalpy2TextField.text = betterCompoundDictionary[compound2TextField.text!]
            }
            
            if betterCompoundDictionary[compound3TextField.text!] != nil {
                enthalpy3TextField.text = betterCompoundDictionary[compound3TextField.text!]
            }
            
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" {
                calculateEnthalpy()
            }
            
        } else if numberOfTextFields == 4 {
            
            coefficient1TextField.isHidden = false
            coefficient2TextField.isHidden = false
            coefficient3TextField.isHidden = false
            coefficient4TextField.isHidden = false
            coefficient5TextField.isHidden = true
            coefficient6TextField.isHidden = true
            
            compound1TextField.isHidden = false
            compound2TextField.isHidden = false
            compound3TextField.isHidden = false
            compound4TextField.isHidden = false
            compound5TextField.isHidden = true
            compound6TextField.isHidden = true
            
            enthalpy1TextField.isHidden = false
            enthalpy2TextField.isHidden = false
            enthalpy3TextField.isHidden = false
            enthalpy4TextField.isHidden = false
            enthalpy5TextField.isHidden = true
            enthalpy6TextField.isHidden = true
            
            coefficient1TextField.text = String(coefficients[0])
            coefficient2TextField.text = String(coefficients[1])
            coefficient3TextField.text = String(coefficients[2])
            coefficient4TextField.text = String(coefficients[3])
            
            compound1TextField.text = String(compounds[0])
            compound2TextField.text = String(compounds[1])
            compound3TextField.text = String(compounds[2])
            compound4TextField.text = String(compounds[3])
            
            if betterCompoundDictionary[compound1TextField.text!] != nil {
                enthalpy1TextField.text = betterCompoundDictionary[compound1TextField.text!]
            }
            
            if betterCompoundDictionary[compound2TextField.text!] != nil {
                enthalpy2TextField.text = betterCompoundDictionary[compound2TextField.text!]
            }
            
            if betterCompoundDictionary[compound3TextField.text!] != nil {
                enthalpy3TextField.text = betterCompoundDictionary[compound3TextField.text!]
            }
            
            if betterCompoundDictionary[compound4TextField.text!] != nil {
                enthalpy4TextField.text = betterCompoundDictionary[compound4TextField.text!]
            }
            
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" {
                calculateEnthalpy()
            }
            
        } else if numberOfTextFields == 5 {
            
            coefficient1TextField.isHidden = false
            coefficient2TextField.isHidden = false
            coefficient3TextField.isHidden = false
            coefficient4TextField.isHidden = false
            coefficient5TextField.isHidden = false
            coefficient6TextField.isHidden = true
            
            compound1TextField.isHidden = false
            compound2TextField.isHidden = false
            compound3TextField.isHidden = false
            compound4TextField.isHidden = false
            compound5TextField.isHidden = false
            coefficient6TextField.isHidden = true
            
            enthalpy1TextField.isHidden = false
            enthalpy2TextField.isHidden = false
            enthalpy3TextField.isHidden = false
            enthalpy4TextField.isHidden = false
            enthalpy5TextField.isHidden = false
            enthalpy6TextField.isHidden = true
            
            coefficient1TextField.text = String(coefficients[0])
            coefficient2TextField.text = String(coefficients[1])
            coefficient3TextField.text = String(coefficients[2])
            coefficient4TextField.text = String(coefficients[3])
            coefficient5TextField.text = String(coefficients[4])
            
            compound1TextField.text = String(compounds[0])
            compound2TextField.text = String(compounds[1])
            compound3TextField.text = String(compounds[2])
            compound4TextField.text = String(compounds[3])
            compound5TextField.text = String(compounds[4])
            
            
            if betterCompoundDictionary[compound1TextField.text!] != nil {
                enthalpy1TextField.text = betterCompoundDictionary[compound1TextField.text!]
            }
            
            if betterCompoundDictionary[compound2TextField.text!] != nil {
                enthalpy2TextField.text = betterCompoundDictionary[compound2TextField.text!]
            }
            
            if betterCompoundDictionary[compound3TextField.text!] != nil {
                enthalpy3TextField.text = betterCompoundDictionary[compound3TextField.text!]
            }
            
            if betterCompoundDictionary[compound4TextField.text!] != nil {
                enthalpy4TextField.text = betterCompoundDictionary[compound4TextField.text!]
            }
            
            if betterCompoundDictionary[compound5TextField.text!] != nil {
                enthalpy5TextField.text = betterCompoundDictionary[compound5TextField.text!]
            }
            
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy5TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" && enthalpy5TextField.text != "" {
                calculateEnthalpy()
            }
            
        } else if numberOfTextFields == 6 {
            
            coefficient1TextField.isHidden = false
            coefficient2TextField.isHidden = false
            coefficient3TextField.isHidden = false
            coefficient4TextField.isHidden = false
            coefficient5TextField.isHidden = false
            coefficient6TextField.isHidden = false
            
            compound1TextField.isHidden = false
            compound2TextField.isHidden = false
            compound3TextField.isHidden = false
            compound4TextField.isHidden = false
            compound5TextField.isHidden = false
            compound6TextField.isHidden = false
            
            enthalpy1TextField.isHidden = false
            enthalpy2TextField.isHidden = false
            enthalpy3TextField.isHidden = false
            enthalpy4TextField.isHidden = false
            enthalpy5TextField.isHidden = false
            enthalpy6TextField.isHidden = false
            
            coefficient1TextField.text = String(coefficients[0])
            coefficient2TextField.text = String(coefficients[1])
            coefficient3TextField.text = String(coefficients[2])
            coefficient4TextField.text = String(coefficients[3])
            coefficient5TextField.text = String(coefficients[4])
            coefficient6TextField.text = String(coefficients[6])
            
            compound1TextField.text = String(compounds[0])
            compound2TextField.text = String(compounds[1])
            compound3TextField.text = String(compounds[2])
            compound4TextField.text = String(compounds[3])
            compound5TextField.text = String(compounds[4])
            compound6TextField.text = String(compounds[5])
            
            if betterCompoundDictionary[compound1TextField.text!] != nil {
                enthalpy1TextField.text = betterCompoundDictionary[compound1TextField.text!]
            }
            
            if betterCompoundDictionary[compound2TextField.text!] != nil {
                enthalpy2TextField.text = betterCompoundDictionary[compound2TextField.text!]
            }
            
            if betterCompoundDictionary[compound3TextField.text!] != nil {
                enthalpy3TextField.text = betterCompoundDictionary[compound3TextField.text!]
            }
            
            if betterCompoundDictionary[compound4TextField.text!] != nil {
                enthalpy4TextField.text = betterCompoundDictionary[compound4TextField.text!]
            }
            
            if betterCompoundDictionary[compound5TextField.text!] != nil {
                enthalpy5TextField.text = betterCompoundDictionary[compound5TextField.text!]
            }
            
            if betterCompoundDictionary[compound6TextField.text!] != nil {
                enthalpy6TextField.text = betterCompoundDictionary[compound6TextField.text!]
            }
            
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy5TextField.text != nil && enthalpy6TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" && enthalpy5TextField.text != "" && enthalpy6TextField.text != "" {
                calculateEnthalpy()
            }
        }
    }
    
    func calculateEnthalpy() {
        if reactants == 1 && products == 2 {
            let value1 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let products = value1 + value2
            let theText = "ΔH@rxn$ = " + String(products - value3) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        } else if reactants == 2 && products == 1 {
            let value1 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let reactants = value2 + value3
            let theText = "ΔH@rxn$ = " + String(value1 - reactants) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        } else if reactants == 2 && products == 2 {
            let value1 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value4 = Double(coefficient4TextField.text!)! * Double(enthalpy4TextField.text!)!
            let products = value3 + value4
            let reactants = value1 + value2
            let theText = "ΔH@rxn$ = " + String(products - reactants) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        } else if reactants == 3 && products == 3 {
            let value1 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value4 = Double(coefficient4TextField.text!)! * Double(enthalpy4TextField.text!)!
            let value5 = Double(coefficient5TextField.text!)! * Double(enthalpy5TextField.text!)!
            let value6 = Double(coefficient6TextField.text!)! * Double(enthalpy6TextField.text!)!
            let products = value4 + value5 + value6
            let reactants = value1 + value2 + value3
            let theText = "ΔH@rxn$ = " + String(products - reactants) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        } else if reactants == 2 && products == 3 {
            let value1 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value4 = Double(coefficient4TextField.text!)! * Double(enthalpy4TextField.text!)!
            let value5 = Double(coefficient5TextField.text!)! * Double(enthalpy5TextField.text!)!
            let products = value3 + value4 + value5
            let reactants = value1 + value2
            let theText = "ΔH@rxn$ = " + String(products - reactants) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        } else if reactants == 3 && products == 2 {
            let value1 = Double(coefficient1TextField.text!)! * Double(enthalpy1TextField.text!)!
            let value2 = Double(coefficient2TextField.text!)! * Double(enthalpy2TextField.text!)!
            let value3 = Double(coefficient3TextField.text!)! * Double(enthalpy3TextField.text!)!
            let value4 = Double(coefficient4TextField.text!)! * Double(enthalpy4TextField.text!)!
            let value5 = Double(coefficient5TextField.text!)! * Double(enthalpy5TextField.text!)!
            let products = value4 + value5
            let reactants = value1 + value2 + value3
            let theText = "ΔH@rxn$ = " + String(products - reactants) + " kJ/mol"
            enthalpyLabel.attributedText = theText.customText3()
        }
    }
    
    func clearText() {
        enthalpy1TextField.text = ""
        enthalpy2TextField.text = ""
        enthalpy3TextField.text = ""
        enthalpy4TextField.text = ""
        enthalpy5TextField.text = ""
        enthalpy6TextField.text = ""
        
        compound1TextField.text = ""
        compound2TextField.text = ""
        compound3TextField.text = ""
        compound4TextField.text = ""
        compound5TextField.text = ""
        compound6TextField.text = ""
        
        coefficient1TextField.text = ""
        coefficient2TextField.text = ""
        coefficient3TextField.text = ""
        coefficient4TextField.text = ""
        coefficient5TextField.text = ""
        coefficient6TextField.text = ""
    }
    
    func editText() {
        
        enthalpy1TextField.text = enthalpy1TextField.text
        enthalpy2TextField.text = enthalpy2TextField.text
        enthalpy3TextField.text = enthalpy3TextField.text
        enthalpy4TextField.text = enthalpy4TextField.text
        enthalpy5TextField.text = enthalpy5TextField.text
        enthalpy6TextField.text = enthalpy6TextField.text

        compound1TextField.text = compound1TextField.text
        compound2TextField.text = compound2TextField.text
        compound3TextField.text = compound3TextField.text
        compound4TextField.text = compound4TextField.text
        compound5TextField.text = compound5TextField.text
        compound6TextField.text = compound6TextField.text

        coefficient1TextField.text = coefficient1TextField.text
        coefficient2TextField.text = coefficient2TextField.text
        coefficient3TextField.text = coefficient3TextField.text
        coefficient4TextField.text = coefficient4TextField.text
        coefficient5TextField.text = coefficient5TextField.text
        coefficient6TextField.text = coefficient6TextField.text

        if numberOfTextFields == 3 {
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" {
                calculateEnthalpy()
            }
        } else if numberOfTextFields == 4 {
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" {
                calculateEnthalpy()
            }
        } else if numberOfTextFields == 5 {
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy5TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" && enthalpy5TextField.text != "" {
                calculateEnthalpy()
            }
        } else if numberOfTextFields == 6 {
            if enthalpy1TextField.text != nil && enthalpy2TextField.text != nil && enthalpy3TextField.text != nil && enthalpy4TextField.text != nil && enthalpy5TextField.text != nil && enthalpy6TextField.text != nil && enthalpy1TextField.text != "" && enthalpy2TextField.text != "" && enthalpy3TextField.text != "" && enthalpy4TextField.text != "" && enthalpy5TextField.text != "" && enthalpy6TextField.text != "" {
                calculateEnthalpy()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
