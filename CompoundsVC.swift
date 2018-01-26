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

    @IBOutlet weak var tableView: UITableView!
    var compounds = [String]()
    var formulas = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredCompounds = [String]()
    var filteredFormulas = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Compounds").observe(.childAdded, with: { (snapshot) in
            
            let formula = snapshot.key
            self.formulas.append(formula)
            
            if let compound = snapshot.value {
                self.compounds.append(compound as! String)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        
        // search bar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let compoundname = compounds[indexPath.row]
        let formulaname = formulas[indexPath.row]
        
        let alert = UIAlertController(title: compoundname, message: formulaname, preferredStyle: UIAlertControllerStyle.alert)
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
        
        let formatter = TextFormatter()
        let formattedCompoundName = formatter.fix(formula: formulas[indexPath.row])
        cell?.formulaLabel.attributedText = formattedCompoundName
        
        cell?.nameLabel.text = compounds[indexPath.row].trunc(length: 20)
        cell?.nameLabel.lineBreakMode = .byTruncatingTail
        cell?.nameLabel.adjustsFontSizeToFitWidth = false;
        
        return cell!
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

