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
    var tag = 0
    
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
        
        tabs.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if tabs.selectedSegmentIndex == 0 {
            tag = 0
        } else if tabs.selectedSegmentIndex == 1 {
            tag = 1
        } else if tabs.selectedSegmentIndex == 2 {
            tag = 2
        }
        
        thermoTableView.reloadData()
    }
    
    /* Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compoundData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = thermoTableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as? ThermoCell
        
        if (tag == 0) {
            let compound = compoundData[indexPath.row]
            cell?.compoundLabel.text = compound.name
            cell?.deltaValueLabel.text = compound.enthalpy! + " kJ/mol"
        } else if (tag == 1) {
            let compound = compoundData[indexPath.row]
            cell?.compoundLabel.text = compound.name
            cell?.deltaValueLabel.text = compound.entropy! + " kJ/mol"
        } else if (tag == 2) {
            let compound = compoundData[indexPath.row]
            cell?.compoundLabel.text = compound.name
            cell?.deltaValueLabel.text = compound.spontaneity! + " J/mol•K"
        }
        
        return cell!
    }
}
