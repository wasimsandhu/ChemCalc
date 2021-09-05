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

class ICETableSolver {
    
    var a: Double!
    var b: Double!
    var c: Double!
    var x: Double!
    var Q: Double!
    
    var actualType: String!
    
    func solve(type: String, K: Double, compounds: [String], coefficients: [Int]) -> [Double] {
        
        equilibriumConcentrations.removeAll()
        
        // Simplify equation types
        if type == "R2P2 SL1" || type == "R2P2 SL2" {
            actualType = "R1P2"
        } else if type == "R2P2 SL3" || type == "R2P2 SL4" {
            actualType = "R2P1"
        } else {
            actualType = type
        }
                
        // Equation type: A + B = C
        if actualType == "R2P1" {
            
            // Calculate reaction quotient
            if initialConcentrations[0] != 0.0 && initialConcentrations[1] != 0.0 && initialConcentrations[2] != 0.0 {
                let numerator = initialConcentrations[2]
                let denominator = initialConcentrations[0] * initialConcentrations[1]
                Q = numerator / denominator
            } else {
                Q = K
            }
            
            if Q < K {
                // Q < K: Kx^2 + (-KA-KB-1)x + KAB-C = 0
                a = K
                b = -K * initialConcentrations[0] - K * initialConcentrations[1] - 1
                c = K * initialConcentrations[0] * initialConcentrations[1] - initialConcentrations[2]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[2] + x).rounded(toPlaces: 4))
                
            } else if Q > K {
                // Q > K: Kx^2 + (KA+KB+1)x + KAB-C = 0
                a = K
                b = K * initialConcentrations[0] + K * initialConcentrations[1] + 1
                c = K * initialConcentrations[0] * initialConcentrations[1] - initialConcentrations[2]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] + x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[1] + x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[2] - x).rounded(toPlaces: 4))
                
            } else if initialConcentrations[2] == 0.0 {
                // Reactants A and B are nonzero: Kx^2 + (-KA-KB-1)x + KAB = 0
                a = K
                b = -K * initialConcentrations[0] - K * initialConcentrations[1] - 1
                c = K * initialConcentrations[0] * initialConcentrations[1]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: 4))
                
            } else if initialConcentrations[2] != 0.0 {
                // Product C is nonzero: Kx^2 + x - C = 0
                a = K
                b = 1
                c = -1 * initialConcentrations[2]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: 4))
                equilibriumConcentrations.append(Double(initialConcentrations[2] - x).rounded(toPlaces: 4))
            }
            
        }
        
        return equilibriumConcentrations
    }
    
    func solveQuadraticEquation(a: Double, b: Double, c: Double) -> Double {
        
        var x: Double!
        
        let alpha = b*b
        let beta = 4*a*c
        let gamma = alpha - beta
        let delta = sqrt(gamma)
        
        let xSubtract = (-b - delta) / (2*a)
        let xAdd = (-b + delta) / (2*a)
        
        if xSubtract > 0.0 && xAdd < 0.0 {
            x = xSubtract
        } else if xAdd > 0.0 && xSubtract < 0.0 {
            x = xAdd
        } else if xAdd > 0.0 && xSubtract > 0.0 {
            if xAdd < xSubtract {
                x = xAdd
            } else {
                x = xSubtract
            }
        }
        
        return x
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

