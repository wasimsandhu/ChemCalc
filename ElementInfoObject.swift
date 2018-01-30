//
//  ElementInfoObject.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/29/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import Foundation

class ElementInfoObject: NSObject {
    
    var atomicMass: String?
    var atomicNumber: String?
    var atomicRadius: String?
    var boilingPoint: String?
    var bondingType: String?
    var density: String?
    var electronAffinity: String?
    var electronegativity: String?
    var electronicConfiguration: String?
    var groupBlock: String?
    var ionRadius: String?
    var ionizationEnergy: String?
    var meltingPoint: String?
    var name: String?
    var oxidationStates: String?
    var standardState: String?
    var symbol: String?
    var vanDelWaalsRadius: String?
    var yearDiscovered: String?
    var cpkHexColor: String?
    
    init(dictionary: [String: AnyObject]) {
        self.atomicMass = dictionary["atomicMass"] as? String ?? ""
        self.atomicNumber = dictionary["atomicNumber"] as? String ?? ""
        self.atomicRadius = dictionary["atomicRadius"] as? String ?? ""
        self.boilingPoint = dictionary["boilingPoint"] as? String ?? ""
        self.bondingType = dictionary["bondingType"] as? String ?? ""
        self.density = dictionary["density"] as? String ?? ""
        self.electronAffinity = dictionary["electronAffinity"] as? String ?? ""
        self.electronegativity = dictionary["electronegativity"] as? String ?? ""
        self.electronicConfiguration = dictionary["electronicConfiguration"] as? String ?? ""
        self.groupBlock = dictionary["groupBlock"] as? String ?? ""
        self.ionRadius = dictionary["ionRadius"] as? String ?? ""
        self.ionizationEnergy = dictionary["ionizationEnergy"] as? String ?? ""
        self.meltingPoint = dictionary["meltingPoint"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.oxidationStates = dictionary["oxidationStates"] as? String ?? ""
        self.standardState = dictionary["standardState"] as? String ?? ""
        self.symbol = dictionary["symbol"] as? String ?? ""
        self.vanDelWaalsRadius = dictionary["vanDelWaalsRadius"] as? String ?? ""
        self.yearDiscovered = dictionary["yearDiscovered"] as? String ?? ""
        self.cpkHexColor = dictionary["cpkHexColor"] as? String ?? ""
    }
}
