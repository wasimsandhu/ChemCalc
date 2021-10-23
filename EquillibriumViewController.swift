//
//  EquillibriumViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 6/4/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

var yesScroll = false
var iceIndex: Int?

class EquillibriumViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var equationTextField: UITextField!
    @IBOutlet weak var kaTextField: UITextField!
    @IBOutlet weak var balancedEquationTextView: UILabel!
    
    var stoichCalc: Stoichiometry!
    
    var coefficients = [Int]()
    var compounds = [String]()
    var concentrations = [Double]()
    var equationType: String?
    var equilibriumConstant: Double?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        // Scroll tableview with text field input
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Keyboard Notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        if yesScroll {
            if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                table.contentInset = UIEdgeInsetsMake(0, 0, CGFloat(220.0), 0)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        yesScroll = false
        UIView.animate(withDuration: 0.2, animations: {
            self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == equationTextField {
            balanceEquation()
        } else if textField == kaTextField {
            if self.kaTextField.text != nil {
                equilibriumConstant = Double(self.kaTextField.text!)
            }
            kaTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == equationTextField {
            balanceEquation()
        } else if textField == kaTextField {
            if self.kaTextField.text != nil {
                equilibriumConstant = Double(self.kaTextField.text!)
            }
            kaTextField.resignFirstResponder()
        }
        return true
    }
    
    func balanceEquation() {
        
        initialConcentrations.removeAll()
        kaTextField.text = ""
        
        if equationTextField.text != nil && equationTextField.text!.contains("=") {
            
            let balancer = ChemicalEquationBalancer()
            coefficients = balancer.setupMatrix(input: equationTextField.text!)
            compounds = balancer.getCompounds()
            let formatter = TextFormatter()
            
            var completeEquation = NSMutableAttributedString()
            var coefficient: NSMutableAttributedString!
            let plus = NSMutableAttributedString(string: " + ", attributes: nil)
            let equals = NSMutableAttributedString(string: " → ", attributes: nil)
            let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
            
            if balancer.getReactants().count == 2 && balancer.getProducts().count == 2 {
                
                equationType = "R2P2"
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 3 && balancer.getProducts().count == 3 {
                
                equationType = "R3P3"
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 1 && balancer.getProducts().count == 1 {

                equationType = "R1P1"
                
                coefficient = NSMutableAttributedString(string: String(coefficients[0]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[0]))
                completeEquation.append(equals)
                coefficient = NSMutableAttributedString(string: String(coefficients[1]), attributes: bold)
                completeEquation.append(coefficient)
                completeEquation.append(formatter.fix(formula: compounds[1]))
                
                balancedEquationTextView.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 2 && balancer.getProducts().count == 1 {
                
                equationType = "R2P1"
                
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
                
                balancedEquationTextView.attributedText = completeEquation

            } else if balancer.getReactants().count == 1 && balancer.getProducts().count == 2 {
                
                equationType = "R1P2"
                
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
                                
                balancedEquationTextView.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 2 && balancer.getProducts().count == 3 {
                
                equationType = "R2P3"
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
            } else if balancer.getReactants().count == 3 && balancer.getProducts().count == 2 {
                
                equationType = "R3P2"
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
            } else {
                let alert = UIAlertController(title: "Whoops!", message: "Looks like this equation is not supported yet. Sorry!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dang okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
                equationTextField.resignFirstResponder()
            }
            
            equationTextField.resignFirstResponder()
        } else {
            let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols, including states of matter.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
            equationTextField.resignFirstResponder()
        }
        
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        for compound in compounds {
            let index = compounds.index(of: compound)
            
            if compound.contains(find: "(s)") || compound.contains(find: "(l)") {
                compounds.remove(at: index!)
                coefficients.remove(at: index!)
                equationType = equationType! + " SL" + String(index! + 1)
            }
            
            initialConcentrations.append(0.0)
        }
        
        return compounds.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ice_cell", for: indexPath) as? ICECell
        
        // Add formulas to table
        var yeet = NSMutableAttributedString()
        let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
        let comp = TextFormatter().fix(formula: compounds[indexPath.row])
        let coff = NSMutableAttributedString(string: String(coefficients[indexPath.row]), attributes: bold)
        yeet.append(coff)
        yeet.append(comp)
        cell?.formulaLabel.attributedText = yeet
        
        // Initial concentrations
        cell?.iceCellIndex = indexPath.row
        cell?.concTextField.text = ""
        
        return cell!
    }
        
    @IBAction func solveButton(_ sender: Any) {
        
        let iceTableSolver = ICETableSolver()
        
        if (equationType != nil && equilibriumConstant != nil) {
            
            concentrations = iceTableSolver.solve(type: equationType!, K: equilibriumConstant!, compounds: compounds, coefficients: coefficients)
            
            // Check if any reactants have an initial concentration of 0
            if !zeroInDenominator {
                
                if !reactionQuotientEqualsK {
                                    
                    var concentrationsText = "\nQ = " + String(iceTableSolver.Q.rounded(toPlaces: 4)) + "\n\nx = " + String(iceTableSolver.x.rounded(toPlaces: 4)) + "\n"
                    
                    for compound in iceTableSolver.localCompounds {
                        let index = iceTableSolver.localCompounds.index(of: compound)
                        concentrationsText += "\n[" + compound + "] = " + String(concentrations[index!]) + " M\n"
                    }
                                        
                    // Show results
                    let alert = UIAlertController(title: "Equilibrium Concentrations", message: concentrationsText, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Nice", style: UIAlertActionStyle.default))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                                    
                    var concentrationsText = "\nQ = K = " + String(iceTableSolver.Q.rounded(toPlaces: 4)) + "\n\nx = " + String(iceTableSolver.x.rounded(toPlaces: 4)) + "\n"

                    for compound in iceTableSolver.localCompounds {
                        let index = iceTableSolver.localCompounds.index(of: compound)
                        concentrationsText += "\n[" + compound + "] = " + String(initialConcentrations[index!]) + " M\n"
                    }
                    
                    // Show results
                    let alert = UIAlertController(title: "Already at equilibrium", message: concentrationsText, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Nice", style: UIAlertActionStyle.default))
                    self.present(alert, animated: true, completion: nil)
                }
            
            } else {
                let alert = UIAlertController(title: "Invalid initial concentration(s)", message: "It looks like one or more reactants has an initial concentration of zero, resulting in an undefined value.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Error message
            let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered in the chemical equation, equilibrium constant, and ALL initial concentrations.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

class ICECell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var concTextField: UITextField!
    var initialConcentration: Double?
    var iceCellIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        concTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if iceCellIndex! >= 1 {
            yesScroll = true
            iceIndex = iceCellIndex
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == concTextField {
                        
            if (self.concTextField.text != nil && iceCellIndex != nil) {
                
                let indexIsValid = initialConcentrations.indices.contains(iceCellIndex!)
                
                // Prevents crash upon invalid concentration entry
                if self.concTextField.text! == " " || self.concTextField.text! == "" {
                    initialConcentration = 0.0
                } else {
                    initialConcentration = Double(self.concTextField.text!)
                }
                
                // Checks to see if array already has a spot for value or not
                if indexIsValid {
                    initialConcentrations[iceCellIndex ?? 0] = initialConcentration ?? 0
                } else if !indexIsValid {
                    initialConcentrations.insert(initialConcentration!, at: iceCellIndex!)
                }
            }
            
            concTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == concTextField {
                        
            if (self.concTextField.text != nil && iceCellIndex != nil) {
                
                let indexIsValid = initialConcentrations.indices.contains(iceCellIndex!)
                
                // Prevents crash upon invalid concentration entry
                if self.concTextField.text! == " " || self.concTextField.text! == "" {
                    initialConcentration = 0.0
                } else {
                    initialConcentration = Double(self.concTextField.text!)
                }
                
                // Checks to see if array already has a spot for value or not
                if indexIsValid {
                    initialConcentrations[iceCellIndex ?? 0] = initialConcentration ?? 0
                } else if !indexIsValid {
                    initialConcentrations.insert(initialConcentration!, at: iceCellIndex!)
                }
            }
            
            concTextField.resignFirstResponder()
        }
    }
    
}

