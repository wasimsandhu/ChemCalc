//
//  DissociationVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 4/4/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DissociationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var acids = [DissociationConstantObject]()
    var bases = ["(C2H5)2NH", "(C2H5)3N", "(CH3)2NH", "(CH3)3N", "C10H14N2", "C13H16CINO", "C17H19NO3", "C18H21NO3", "C21H22N2O2", "C2H5NH2", "C2H8N2", "C3H7NH2", "C5H10NH", "C5H5N", "C6H5NH2", "CH3NH2", "H2NNH2", "HONH2", "NH3"]
    var isFiltering = false
    var filteredAcids = [DissociationConstantObject]()
    var acidName: DissociationConstantObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Firebase database reference
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Ka Constants").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let acid = DissociationConstantObject(dictionary: dictionary)
                self.acids.append(acid)
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
        let cell = tableView.cellForRow(at: indexPath) as! DissociationCell
        let vc = storyboard?.instantiateViewController(withIdentifier: "KaKbVC") as! KaKbVC
        
        let compound = cell.name.text
        if bases.contains(compound!) { vc.isBase = true }
        if isFiltering {
            vc.acidInfo = filteredAcids[indexPath.row]
        } else {
            vc.acidInfo = acids[indexPath.row]
        }
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredAcids.count
        } else {
            return acids.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dcell", for: indexPath) as! DissociationCell
       
        if isFiltering {
            acidName = filteredAcids[indexPath.row]
        } else {
            acidName = acids[indexPath.row]
        }
        
        cell.name.attributedText = TextFormatter().fix(formula: acidName.name!)
        cell.constant.attributedText = TextFormatter().scientificNotation(number: acidName.Ka1!)

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isFiltering = false
            tableView.reloadData()
        } else {
            isFiltering = true
            filteredAcids = acids.filter({$0.name?.range(of: searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

class DissociationConstantObject: NSObject {
    
    var name: String?
    var Ka1: String?
    var Ka2: String?
    var Ka3: String?
    
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String ?? ""
        self.Ka1 = dictionary["Ka1"] as? String ?? ""
        self.Ka2 = dictionary["Ka2"] as? String ?? ""
        self.Ka3 = dictionary["Ka3"] as? String ?? ""
    }
    
}

class DissociationCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var constant: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
