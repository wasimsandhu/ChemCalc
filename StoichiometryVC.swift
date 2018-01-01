//
//  EquationsViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 9/7/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class StoichiometryVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var equationTextField: UITextField!
    @IBOutlet weak var reactantTextField1: UITextField!
    @IBOutlet weak var reactantTextField2: UITextField!
    @IBOutlet weak var productsTableView: UITableView!
    
    let balancer = ChemicalEquationBalancer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* Text Fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        input = self.textField.text
        
        if (textField == equationTextField) {
            balancer.getElements(equation: input)
        } else if (textField == reactantTextField1) {
            
        } else if (textField == reactantTextField2) {
            
        }
        
        textField.resignFirstResponder()
        return true
    } */
    
    /* Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "pcell", for: indexPath) as? StoichCell
        
        if indexPath.row == 0 {
            // Limiting reactant
            cell?.labelLabel.text = "Limiting Reactant"
        } else if indexPath.row == 1 {
            // Theoretical yield of product 1 in grams
            cell?.labelLabel.text = "Theoretical yield of Product 1"
        } else if indexPath.row == 2 {
            // Theoretical yield of product 1 in moles
            cell?.labelLabel.text = "Moles of Product 1"
        } else if indexPath.row == 3 {
            // Theoretical yield of product 2 in grams
            cell?.labelLabel.text = "Theoretical yield of Product 2"
        } else if indexPath.row == 4 {
            // Theoretical yield of product 2 in moles
            cell?.labelLabel.text = "Moles of Product 2"
        } else if indexPath.row == 5 {
            // Amount of excess reactant left
            cell?.labelLabel.text = "Amount of excess reactant left"
        }
     
        return cell!
    }
}
