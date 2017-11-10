//
//  ThermoDataObject.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 10/17/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import Foundation

class ThermoDataObject: NSObject {
    var name: String?
    var enthalpy: String?
    var entropy: String?
    var spontaneity: String?
    
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String ?? ""
        self.enthalpy = dictionary["enthalpy"] as? String ?? ""
        self.entropy = dictionary["entropy"] as? String ?? ""
        self.spontaneity = dictionary["spontaneity"] as? String ?? ""
    }
}
