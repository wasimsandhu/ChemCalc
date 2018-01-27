//
//  SolubilityChecker.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/26/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import Foundation

class SolubilityChecker {
    
    var isSoluble = false
    
    // NOTE: algorithm is for ionic compound solubility only
    func checkSolubility(of: String) -> Bool {
        let compound = of
        
        if compound.contains("Li") || compound.contains("Na") || compound.contains("K") || compound.contains("NH4") || compound.contains("NO3") || compound.contains("C2H3O2") {
            isSoluble = true
            
        } else if compound.contains("Cl") || compound.contains("Br") || compound.contains("I") {
            
            if compound.contains("Ag") || compound.contains("Hg2") || compound.contains("Pb") {
                isSoluble = false
            } else {
                isSoluble = true
            }
            
        } else if compound.contains("SO4") {
            
            if compound.contains("Sr") || compound.contains("Ba") || compound.contains("Pb") || compound.contains("Ag") || compound.contains("Ca") {
                isSoluble = false
            } else {
                isSoluble = true
            }
            
        } else if compound.contains("OH") {
            
            if compound.contains("Li") || compound.contains("Na") || compound.contains("K") || compound.contains("NH4") || compound.contains("Ca") || compound.contains("Sr") || compound.contains("Ba") {
                isSoluble = true
            } else {
                isSoluble = false
            }
            
        } else if compound.hasSuffix("S") {
            
            if compound.contains("Ca") || compound.contains("Sr") || compound.contains("Ba") {
                isSoluble = true
            } else {
                isSoluble = false
            }
            
        } else if compound.contains("CO3") || compound.contains("PO4") {
            
            if compound.contains("Li") || compound.contains("Na") || compound.contains("K") || compound.contains("NH4") {
                isSoluble = true
            } else {
                isSoluble = false
            }
            
        } else {
            isSoluble = false
        }
        
        return isSoluble
    }
    
}
