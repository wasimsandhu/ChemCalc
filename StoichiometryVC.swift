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
    @IBOutlet weak var stoichTableView: UITableView!
    @IBOutlet weak var balanceTableView: UITableView!
    
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
    var readyForStoich = false
    
    @IBOutlet weak var equationType: UILabel!
    @IBOutlet weak var balancedEquation: UILabel!
    var coefficients = [Int]()
    var compounds = [String]()
    
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
        
        balanceTableView.layoutMargins = UIEdgeInsets.zero
        balanceTableView.separatorInset = UIEdgeInsets.zero
        
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
            
            if readyForStoich == true {
                if textFieldIsNil() == false && textIsAcceptable {
                    limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                    excessReactantLeft = stoichCalc.getExcessReactant()
                    theoreticalYield = nil
                    stoichTableView.reloadData()
                    readyForStoich = false
                }
            }
        }
    }
    
    // text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == balanceTextField {
            balanceTextField.selectedTextRange = balanceTextField.textRange(from: balanceTextField.beginningOfDocument, to: balanceTextField.endOfDocument)
        } else {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        getText()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == balanceTextField {
            balanceEquation()
        }
        
        if textField == firstReactantTextField {
            self.firstReactantTextField.text! = (firstReactantTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            firstReactantTextField.resignFirstResponder()
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                excessReactantLeft = stoichCalc.getExcessReactant()
                
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
                readyForStoich = false
            } else {
                firstAmountTextField.becomeFirstResponder()
            }
            
        } else if textField == firstAmountTextField {
            self.firstAmountTextField.text! = (firstAmountTextField.text?.replacingOccurrences(of: " ", with: ""))!
            firstAmount = Double(firstAmountTextField.text!)
            getText()
            self.firstAmountTextField.text! += " g"
            firstAmountTextField.resignFirstResponder()
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                excessReactantLeft = stoichCalc.getExcessReactant()
                
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
                readyForStoich = false
            } else {
                firstCoefficientTextField.becomeFirstResponder()
            }
            
        } else if textField == firstCoefficientTextField {
            self.firstCoefficientTextField.text! = (firstCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            firstCoefficientTextField.resignFirstResponder()

            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                excessReactantLeft = stoichCalc.getExcessReactant()
                
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
                readyForStoich = false
            } else {
                secondReactantTextField.becomeFirstResponder()
            }
            
        } else if textField == secondReactantTextField {
            self.secondReactantTextField.text! = (secondReactantTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            secondReactantTextField.resignFirstResponder()
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                excessReactantLeft = stoichCalc.getExcessReactant()
                
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
                readyForStoich = false
            } else {
                secondAmountTextField.becomeFirstResponder()
            }
            
        } else if textField == secondAmountTextField {
            self.secondAmountTextField.text! = (secondAmountTextField.text?.replacingOccurrences(of: " ", with: ""))!
            secondAmount = Double(secondAmountTextField.text!)
            getText()
            secondAmountTextField.resignFirstResponder()
            self.secondAmountTextField.text! += " g"
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                excessReactantLeft = stoichCalc.getExcessReactant()
                
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
                readyForStoich = false
            } else {
                secondCoefficientTextField.becomeFirstResponder()
            }
            
        } else if textField == secondCoefficientTextField {
            self.secondCoefficientTextField.text! = (secondCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            secondCoefficientTextField.resignFirstResponder()
            
            if textFieldIsNil() == false && textIsAcceptable {
                limitingReactant = stoichCalc.getLimitingReactant(reactant1: firstReactant!, amount1: firstAmount!, coefficient1: firstCoefficient!, reactant2: secondReactant!, amount2: secondAmount!, coefficient2: secondCoefficient!)
                
                excessReactantLeft = stoichCalc.getExcessReactant()
                if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                    theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
                } else {
                    theoreticalYield = nil
                }
                
                stoichTableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "One or more text fields were not completed. Please check that your compound formula, reactant amount, and coefficient from the balanced chemical equation have been inputted correctly.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else if textField == productTextField {
            self.productTextField.text! = (productTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            productTextField.resignFirstResponder()
            
            if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
            } else {
                productCoefficientTextField.becomeFirstResponder()
            }
            
        } else if textField == productCoefficientTextField {
            self.productCoefficientTextField.text! = (productCoefficientTextField.text?.replacingOccurrences(of: " ", with: ""))!
            getText()
            productCoefficientTextField.resignFirstResponder()
            
            if product != nil && productCoefficient != nil && textFieldIsNil() == false && textIsAcceptable {
                theoreticalYield = stoichCalc.getTheoreticalYield(product: product!, productCoefficient: productCoefficient!)
            } else {
                let alert = UIAlertController(title: "Error", message: "One or more text fields were not completed. Please check that your compound formula, reactant amount, and coefficient from the balanced chemical equation have been inputted correctly.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
            }
            
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
        if firstReactant == nil || firstReactant == "" || firstAmount == nil || firstCoefficient == nil || secondReactant == nil || secondReactant == "" || secondAmount == nil || secondCoefficient == nil {
            return true
        } else {
            return false
        }
    }
    
    func getText() {
        firstReactant = firstReactantTextField.text
        secondReactant = secondReactantTextField.text
        firstCoefficient = Int(firstCoefficientTextField.text!)
        secondCoefficient = Int(secondCoefficientTextField.text!)
        productCoefficient = Int(productCoefficientTextField.text!)
        product = productTextField.text
    }
    
    @IBAction func clear(_ sender: Any) {
        firstReactantTextField.text = ""
        secondReactantTextField.text = ""
        firstAmountTextField.text = ""
        secondAmountTextField.text = ""
        firstCoefficientTextField.text = ""
        secondCoefficientTextField.text = ""
        productCoefficientTextField.text = ""
        productTextField.text = ""
        firstReactant = nil
        secondReactant = nil
        product = nil
        firstAmount = nil
        secondAmount = nil
        firstCoefficient = nil
        secondCoefficient = nil
        productCoefficient = nil
    }
    
    func getReadyForStoich() {
        firstReactantTextField.text = compounds[0]
        firstReactant = compounds[0]
        firstAmountTextField.text = "5.00 g"
        firstAmount = 5.00
        firstCoefficientTextField.text = String(coefficients[0])
        firstCoefficient = coefficients[0]
        
        secondReactantTextField.text = compounds[1]
        secondReactant = compounds[1]
        secondAmountTextField.text = "5.00 g"
        secondAmount = 5.00
        secondCoefficientTextField.text = String(coefficients[1])
        secondCoefficient = coefficients[1]
        
        product = nil
        productTextField.text = ""
        productCoefficient = nil
        productCoefficientTextField.text = ""
        
        readyForStoich = true
    }
    
    func balanceEquation() {
        if (balanceTextField.text?.contains("+"))! && (balanceTextField.text?.contains("="))! {
            
            let balancer = ChemicalEquationBalancer()
            coefficients = balancer.setupMatrix(input: balanceTextField.text!)
            compounds = balancer.getCompounds()
            let formatter = TextFormatter()
            
            var completeEquation = NSMutableAttributedString()
            var coefficient: NSMutableAttributedString!
            let plus = NSMutableAttributedString(string: " + ", attributes: nil)
            let equals = NSMutableAttributedString(string: " → ", attributes: nil)
            let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
            
            if balancer.getReactants().count == 2 && balancer.getProducts().count == 2 {
                
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
                
                if compounds[2] == "CO2" && compounds[3] == "H2O" {
                    equationType.text = "Combustion Reaction"
                } else if compounds[2] == "H2O" && compounds[3] == "CO2" {
                    equationType.text = "Combustion Reaction"
                } else if balancer.getReactants().count == balancer.getProducts().count {
                    equationType.text = "Double Replacement Reaction"
                } else {
                    equationType.text = "Balance Chemical Equations"
                }
                
                balancedEquation.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 3 && balancer.getProducts().count == 3 {
                
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
                
                equationType.text = "Balance Chemical Equations"
                balancedEquation.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 1 && balancer.getProducts().count == 1 {
                equationType.text = "Balance Chemical Equations"
            } else if balancer.getReactants().count == 2 && balancer.getProducts().count == 1 {
                
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
                
                equationType.text = "Synthesis Reaction"
                balancedEquation.attributedText = completeEquation

            } else if balancer.getReactants().count == 1 && balancer.getProducts().count == 2 {
                
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
                
                equationType.text = "Decomposition Reaction"
                balancedEquation.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 2 && balancer.getProducts().count == 3 {
                
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
                
                equationType.text = "Balance Chemical Equations"
                balancedEquation.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 3 && balancer.getProducts().count == 2 {
                
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
                
                equationType.text = "Balance Chemical Equations"
                balancedEquation.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 3 && balancer.getProducts().count == 3 {
                
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
                
                equationType.text = "Balance Chemical Equations"
                balancedEquation.attributedText = completeEquation
                
            } else {
                let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
                balanceTextField.resignFirstResponder()
            }
            
            balanceTextField.resignFirstResponder()
            balanceTableView.reloadData()
            getReadyForStoich()
        } else {
            let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
            balanceTextField.resignFirstResponder()
        }
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == stoichTableView {
            return 3
        } else if tableView == balanceTableView {
            return compounds.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stoichcell") as? StoichCell
        cell?.layoutMargins = UIEdgeInsets.zero
        if tableView == stoichTableView {
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
        } else if tableView == balanceTableView {
            var yeet = NSMutableAttributedString()
            let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
            let comp = TextFormatter().fix(formula: compounds[indexPath.row])
            let coff = NSMutableAttributedString(string: String(coefficients[indexPath.row]), attributes: bold)
            yeet.append(coff)
            yeet.append(comp)
            cell?.keyLabel2.attributedText = yeet
            cell?.valueLabel2.text = String(MolarMassCalculator().calculate(compound: compounds[indexPath.row])) + " g/mol"
        }
        
        return cell!
    }
    
    
    @IBAction func loadLearnView(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LearnViewController") as! LearnViewController
        vc.webpage = "stoichiometry"
        vc.barTitle = "Stoichiometry"
        navigationController?.pushViewController(vc, animated: true)
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

class StoichCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var keyLabel2: UILabel!
    @IBOutlet weak var valueLabel2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

