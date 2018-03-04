//
//  ThermodynamicsVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 10/17/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThermodynamicsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var thermoTableView: UITableView!
    @IBOutlet weak var tabs: UISegmentedControl!
    var compoundData = [ThermoDataObject]()
    var compound: ThermoDataObject!
    var tag = 0
    
    // search bar variables
    var filteredData = [ThermoDataObject]()
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false

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
        
        // tab selection listener
        tabs.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // search bar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
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
        
        if isSearching {
            return filteredData.count
        } else {
            return compoundData.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = thermoTableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as? ThermoCell

        if isSearching {
            compound = filteredData[indexPath.row]
        } else {
           compound = compoundData[indexPath.row]
        }
        
        let formatter = TextFormatter()
        let formattedCompoundName = formatter.fix(formula: compound.name!)
        
        if (tag == 0) {
            cell?.compoundLabel.attributedText = formattedCompoundName
            cell?.deltaValueLabel.text = compound.enthalpy! + " kJ/mol"
        } else if (tag == 1) {
            cell?.compoundLabel.attributedText = formattedCompoundName
            cell?.deltaValueLabel.text = compound.entropy! + " kJ/mol"
        } else if (tag == 2) {
            cell?.compoundLabel.attributedText = formattedCompoundName
            cell?.deltaValueLabel.text = compound.spontaneity! + " J/mol•K"
        }
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isSearching = false
            thermoTableView.reloadData()
        } else {
            isSearching = true
            filteredData = compoundData.filter({$0.name?.range(of: searchBar.text!) != nil})
            thermoTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
