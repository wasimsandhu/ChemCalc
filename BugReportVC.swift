//
//  BugReportVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 3/1/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BugReportVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var name: UITextField!
    
    var fullName: String!
    var bugReport: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        name.delegate = self
        emailAddress.delegate = self
        textView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            name.resignFirstResponder()
            emailAddress.becomeFirstResponder()
        } else if textField == emailAddress {
            emailAddress.resignFirstResponder()
            textView.becomeFirstResponder()
        } else {
            
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func submit(_ sender: Any) {
        fullName = name.text
        email = emailAddress.text
        bugReport = textView.text
        bugReport.cutText(length: 200)
        
        if bugReport != nil && bugReport != "" && fullName != "" && fullName != nil && email != nil && email != "" {
            let bugsReference = FIRDatabase.database().reference().child("Bugs").child(fullName)
            let bug = ["name": fullName, "email": email, "report": bugReport]
            bugsReference.setValue(bug)
            let alert = UIAlertController(title: "Bug Report Sent", message: "Thank you! Your feedback is greatly appreciated. I will get back to you as soon as possible.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Fantastic", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Bug Report Failed", message: "Please double-check to make sure you've entered your name and email address.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension String {
    func cutText(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}
