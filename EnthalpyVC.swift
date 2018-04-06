//
//  EnthalpyVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 4/5/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class EnthalpyVC: UIViewController {

    @IBOutlet weak var reactionTextField: UITextField!
    @IBOutlet weak var balancedEquationText: UILabel!
    
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
    
    @IBOutlet weak var enthalpyOfReaction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
