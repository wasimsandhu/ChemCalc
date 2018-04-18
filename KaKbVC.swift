//
//  KaKbVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 4/5/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class KaKbVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var acidInfo: DissociationConstantObject!
    var isBase = false
    var numberOfConstants: Int!
    var compoundName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if acidInfo.Ka2 == "N/A" {
            numberOfConstants = 1
        } else if acidInfo.Ka2 != "N/A" && acidInfo.Ka3 == "N/A" {
            numberOfConstants = 2
        } else {
            numberOfConstants = 3
        }
        self.navigationItem.title = acidInfo.name!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfConstants
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isBase {
            return "Base Dissociation Constant"
        } else {
            return "Acid Dissociation Constant"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kacell", for: indexPath) as! KaCell
        
        if numberOfConstants == 1 {

            if indexPath.row == 0 {
                if isBase == true {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Kb")
                } else {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka1")
                }
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka1!)
            }
            
        } else if numberOfConstants == 2 {
            
            if indexPath.row == 0 {
                if isBase == true {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Kb")
                } else {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka1")
                }
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka1!)
            } else if indexPath.row == 1 {
                cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka2")
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka2!)
            }
            
        } else if numberOfConstants == 3 {
            
            if indexPath.row == 0 {
                if isBase == true {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Kb")
                } else {
                    cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka1")
                }
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka1!)
            } else if indexPath.row == 1 {
                cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka2")
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka2!)
            } else if indexPath.row == 2 {
                cell.constantLabel.attributedText = TextFormatter().ka(letters: "Ka3")
                cell.valueLabel.attributedText = TextFormatter().scientificNotation(number: acidInfo.Ka3!)
            }
            
        }

        return cell
    }
}

class KaCell: UITableViewCell {
    
    @IBOutlet weak var constantLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
