//
//  MoreViewController.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/9/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import UIKit
import MessageUI

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
        
    @IBOutlet weak var moreTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "More Calculators" as String?
        } else if section == 1 {
            return "Reference" as String?
        } else if section == 2 {
            return "App Feedback" as String?
        } else {
            return "" as String?
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 7
        } else if section == 2 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "morecell", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Enthalpy, Entropy, and Spontaneity"
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Compounds and formulas"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Polyatomic ions and charges"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Thermodynamic data"
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Acid/base dissociation constants"
            } else if indexPath.row == 4 {
                cell.textLabel?.text = "Solubility checker"
            } else if indexPath.row == 5 {
                cell.textLabel?.text = "Solubility product constants"
            } else if indexPath.row == 6 {
                cell.textLabel?.text = "Standard electrode potentials"
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Contact the developer"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Credits and libraries"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "showEnthalpy", sender: indexPath)
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "showCompounds", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: "showPolyatomicIons", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            performSegue(withIdentifier: "showThermo", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 3 {
            performSegue(withIdentifier: "showKa", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 4 {
            performSegue(withIdentifier: "showSolubility", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 5 {
            performSegue(withIdentifier: "showKsp", sender: indexPath)
        } else if indexPath.section == 1 && indexPath.row == 6 {
            performSegue(withIdentifier: "showElectrode", sender: indexPath)
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["wasim@wasimsandhu.com"])
            mailComposerVC.setSubject("App Feedback: ChemCalc")
            mailComposerVC.setMessageBody("", isHTML: false)
            presentMailComposeViewController(mailComposeViewController: mailComposerVC)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            performSegue(withIdentifier: "showCredits", sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentMailComposeViewController(mailComposeViewController: MFMailComposeViewController) {
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController.init(title: "Error", message: "Unable to send email. Please check your email settings and try again.", preferredStyle: .alert)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) { switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "Failed", message: "Unable to send email. Please check your email settings and try again.", preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            })
        default: break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
