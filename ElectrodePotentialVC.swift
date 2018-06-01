//
//  ElectrodePotentialVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 5/3/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ElectrodePotentialVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var isFiltering = false
    var electrodePotentials = [ElectrodeObject]()
    var filteredPotentials = [ElectrodeObject]()
    var electrodeReaction: ElectrodeObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Electrode Potentials").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let electrode = ElectrodeObject(dictionary: dictionary)
                self.electrodePotentials.append(electrode)
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        
        // search bar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPotentials.count
        } else {
            return electrodePotentials.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "electrode", for: indexPath) as! ElectrodeCell
        
        if isFiltering {
            electrodeReaction = filteredPotentials[indexPath.row]
        } else {
            electrodeReaction = electrodePotentials[indexPath.row]
        }
        
        cell.reactionLabel.attributedText = TextFormatter().fixReaction(formula: electrodeReaction.reaction!.trunc(length: 24))
        cell.potentialLabel.text = electrodeReaction.potential! + " V"
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filteredPotentials = electrodePotentials.filter({$0.reaction?.range(of: searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

class ElectrodeObject: NSObject {
    
    var reaction: String?
    var potential: String?

    init(dictionary: [String: AnyObject]) {
        self.reaction = dictionary["reaction"] as? String ?? ""
        self.potential = dictionary["potential"] as? String ?? ""
    }
    
}

class ElectrodeCell: UITableViewCell {
    
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var potentialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
