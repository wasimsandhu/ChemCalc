//
//  KspViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 5/4/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class KspViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isFiltering = false
    var kspConstants = [KspObject]()
    var filteredKspConstants = [KspObject]()
    var kspObj: KspObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Ksp Constants").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let ksp = KspObject(dictionary: dictionary)
                self.kspConstants.append(ksp)
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
            return filteredKspConstants.count
        } else {
            return kspConstants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kspcell", for: indexPath) as! KspCell
        
        if isFiltering {
            kspObj = filteredKspConstants[indexPath.row]
        } else {
            kspObj = kspConstants[indexPath.row]
        }
        
        cell.compound.attributedText = TextFormatter().fix(formula: kspObj.formula!)
        cell.Ksp.attributedText = TextFormatter().scientificNotation(number: kspObj.Ksp!)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filteredKspConstants = kspConstants.filter({$0.formula?.range(of: searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

class KspObject: NSObject {
    
    var name: String?
    var formula: String?
    var Ksp: String?
    
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String ?? ""
        self.formula = dictionary["formula"] as? String ?? ""
        self.Ksp = dictionary["Ksp"] as? String ?? ""
    }
    
}

class KspCell: UITableViewCell {

    @IBOutlet weak var compound: UILabel!
    @IBOutlet weak var Ksp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
