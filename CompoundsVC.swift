//
//  CompoundsVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/25/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CompoundsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // future wasim: good luck figuring out this mess
    @IBOutlet weak var tableView: UITableView!
    var compounds = [String:String]()
    var compoundArray = [String]()
    var formulaArray = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredCompounds = [String:String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Compounds").observe(.childAdded, with: { (snapshot) in
            
            let formula = snapshot.key
            if let compound = snapshot.value {
                self.compounds[formula] = compound as? String
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        
        formulaArray = Array(compounds.keys)
        compoundArray = Array(compounds.values)
        
        // search bar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let compoundname = compoundArray[indexPath.row]
        let molarmass = MolarMassCalculator().calculate(compound: formulaArray[indexPath.row])
        
        let alert = UIAlertController(title: compoundname, message: String(molarmass) + " g/mol", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCompounds.count
        } else {
            return compounds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "compoundcell", for: indexPath) as? CompoundCell
        
        if isSearching {
            formulaArray = Array(filteredCompounds.keys)
            compoundArray = Array(filteredCompounds.values)
        } else {
            formulaArray = Array(compounds.keys)
            compoundArray = Array(compounds.values)
        }
        
        let formatter = TextFormatter()
        let formattedCompoundName = formatter.fix(formula: formulaArray[indexPath.row])
        cell?.formulaLabel.attributedText = formattedCompoundName
        
        cell?.nameLabel.text = compoundArray[indexPath.row].trunc(length: 26)
        cell?.nameLabel.lineBreakMode = .byTruncatingTail
        cell?.nameLabel.adjustsFontSizeToFitWidth = false;
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredCompounds = compounds.filter({$0.key.lowercased().range(of: searchBar.text!) != nil})
            filteredCompounds = compounds.filter({$0.value.lowercased().range(of: searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    // TODO: Search function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

class CompoundCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

