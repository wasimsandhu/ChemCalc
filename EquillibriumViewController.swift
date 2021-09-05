//
//  EquillibriumViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 6/4/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class EquillibriumViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var equationTextField: UITextField!
    @IBOutlet weak var kaTextField: UITextField!
    @IBOutlet weak var balancedEquationTextView: UILabel!
    
    var iceTableSolver: ICETableSolver!
    var stoichCalc: Stoichiometry!
    
    var coefficients = [Int]()
    var compounds = [String]()
    var concentrations = [Double]()
    var equationType: String?
    var equilibriumConstant: Double?
    
    var solidOrLiquidPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == kaTextField {
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
        if (equationTextField.text?.contains("+"))! && (equationTextField.text?.contains("="))! {
            
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
                let alert = UIAlertController(title: "Something's wrong", message: "Please double-check that you've entered an unbalanced chemical equation using + and = symbols, including states of matter.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
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
        
        return cell!
    }
        
    @IBAction func solveButton(_ sender: Any) {
        let iceTableSolver = ICETableSolver()
        if (equationType != nil && equilibriumConstant != nil) {
            concentrations = iceTableSolver.solve(type: equationType!, K: equilibriumConstant!, compounds: compounds, coefficients: coefficients)

            var concentrationsText = ""
            
            for concentration in concentrations {
                let index = concentrations.index(of: concentration)
                concentrationsText += "\n" + compounds[index!] + ": " + String(concentration) + " M\n"
            }
            
            print(concentrations)
            print(concentrationsText)
            
            let alert = UIAlertController(title: "Equilibrium Concentrations", message: concentrationsText, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Nice", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Error message
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexIsValid = initialConcentrations.indices.contains(iceCellIndex!)
        
        if textField == concTextField {
            if (self.concTextField.text != nil && iceCellIndex != nil) {
                initialConcentration = Double(self.concTextField.text!)
                if indexIsValid {
                    initialConcentrations[iceCellIndex ?? 0] = initialConcentration ?? 0
                } else {
                    initialConcentrations.insert(initialConcentration!, at: iceCellIndex!)
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexIsValid = initialConcentrations.indices.contains(iceCellIndex!)
        
        if textField == concTextField {
            if (self.concTextField.text != nil && iceCellIndex != nil) {
                initialConcentration = Double(self.concTextField.text!)
                if indexIsValid {
                    initialConcentrations[iceCellIndex ?? 0] = initialConcentration ?? 0
                    print(initialConcentrations)
                } else {
                    initialConcentrations.insert(initialConcentration!, at: iceCellIndex!)
                }
            }
        }
    }
    
}

