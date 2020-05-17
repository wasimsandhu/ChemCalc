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
    
    var iceCalc: ICETableAnalysis!
    var stoichCalc: Stoichiometry!
    
    var coefficients = [Int]()
    var compounds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == equationTextField {
            balanceEquation()
        } else if textField == kaTextField {
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
                
                balancedEquationTextView.attributedText = completeEquation

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
                
                balancedEquationTextView.attributedText = completeEquation
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
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
                
                balancedEquationTextView.attributedText = completeEquation
                
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
            
            var index = compounds.index(of: compound)
            
            if compound.contains(find: "(s)") {
                compounds.remove(at: index!)
            }
            
            if compound.contains(find: "(l)") {
                compounds.remove(at: index!)
            }
        }
        
        return compounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ice_cell", for: indexPath) as? ICECell
        var yeet = NSMutableAttributedString()
        let bold = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18)!]
        let comp = TextFormatter().fix(formula: compounds[indexPath.row])
        let coff = NSMutableAttributedString(string: String(coefficients[indexPath.row]), attributes: bold)
        yeet.append(coff)
        yeet.append(comp)
        cell?.formulaLabel.attributedText = yeet
        return cell!
    }
    
    @IBAction func solveICETable(_ sender: Any) {
        iceCalc.solve()
    }
}

class ICECell: UITableViewCell {
    
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var concTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

