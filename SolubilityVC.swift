//
//  SolubilityVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/26/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class SolubilityVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var yesNoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        let checker = SolubilityChecker()
        let compound = self.textField.text
        
        if checker.checkSolubility(of: compound!) == true {
            self.yesNoLabel.text = "Yes!"
        } else if checker.checkSolubility(of: compound!) == false {
            self.yesNoLabel.text = "Nope."
        }

        return true
    }
}
