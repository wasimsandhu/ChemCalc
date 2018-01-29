//
//  MoreViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/9/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var moreTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Reference" as String?
        } else if section == 1 {
            return "About ChemCalc" as String?
        } else {
            return "" as String?
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        } else if section == 1 {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "morecell", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Common chemical compounds"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Polyatomic ions and charges"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Solubility checker"
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "About the developer"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Report bugs and mistakes"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Send feedback"
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Credits and libraries"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "showCompounds", sender: indexPath)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "showPolyatomicIons", sender: indexPath)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            performSegue(withIdentifier: "showSolubility", sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
