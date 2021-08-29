//
//  ICETableSolver.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 8/16/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import Foundation

var initialConcentrations = [Double]()
var equilibriumConcentrations = [Double]()
var solidOrLiquidPresent = true

class ICETableSolver {
    
    var a: Double!
    var b: Double!
    var c: Double!
    var k: Double!
    var x: Double!
    
    var editedCompounds = [String]()
    var editedCoefficients = [Int]()
    
    func solve(type: String, k: Double, compounds: [String], coefficients: [Int]) -> [Double] {
        
        editedCompounds = compounds
        editedCoefficients = coefficients
        
        for compound in editedCompounds {
            let index = editedCompounds.index(of: compound)
            
            if editedCompounds.contains("(s)") || editedCompounds.contains("(l)") {
                solidOrLiquidPresent = true
            }
            
            editedCompounds.remove(at: index!)
            editedCoefficients.remove(at: index!)
        }
        
                
        if solidOrLiquidPresent {
            if type == "R2P2" {
                a = k
                b = (-k * initialConcentrations[0]) - (k * initialConcentrations[1]) - 1
                c = k * initialConcentrations[0] * initialConcentrations[1]
                
                let alpha = b*b
                let beta = 4*a*c
                let gamma = alpha - beta
                let delta = sqrt(gamma)
                x = (-b - delta) / (2*a)
                
                equilibriumConcentrations.append(initialConcentrations[0] - x)
                equilibriumConcentrations.append(initialConcentrations[1] - x)
                equilibriumConcentrations.append(x)
            }
        }
        
        return equilibriumConcentrations
        
    }
    
}
