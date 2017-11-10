//
//  ThermodynamicsVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 10/17/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThermodynamicsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var thermoTableView: UITableView!
    @IBOutlet weak var tabs: UISegmentedControl!
    var compoundData = [ThermoDataObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        
        rootRef.child("Thermodynamics").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let compound = ThermoDataObject(dictionary: dictionary)
                self.compoundData.append(compound)
            }
            
            DispatchQueue.main.async(execute: {
                self.thermoTableView.reloadData()
            })
            
        })
    }
    
    /* Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compoundData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = thermoTableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as? ThermoCell
        
        let compound = compoundData[indexPath.row]
        cell?.compoundLabel.text = compound.name
        cell?.deltaValueLabel.text = compound.enthalpy! + " kJ/mol"
        
        return cell!
    }
}
