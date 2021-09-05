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
    
    var decimalPlaces = 4
    
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
                
        // Equation Type: A + B = C
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
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[2] + x).rounded(toPlaces: decimalPlaces))
                
            } else if Q > K {
                // Q > K: Kx^2 + (KA+KB+1)x + KAB-C = 0
                a = K
                b = K * initialConcentrations[0] + K * initialConcentrations[1] + 1
                c = K * initialConcentrations[0] * initialConcentrations[1] - initialConcentrations[2]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[2] - x).rounded(toPlaces: decimalPlaces))
                
            } else if initialConcentrations[2] == 0.0 {
                // Reactants A and B are nonzero: Kx^2 + (-KA-KB-1)x + KAB = 0
                a = K
                b = -K * initialConcentrations[0] - K * initialConcentrations[1] - 1
                c = K * initialConcentrations[0] * initialConcentrations[1]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                
            } else if initialConcentrations[2] != 0.0 {
                // Product C is nonzero: Kx^2 + x - C = 0
                a = K
                b = 1
                c = -1 * initialConcentrations[2]
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[2] - x).rounded(toPlaces: decimalPlaces))
            }
        }
        
        // Equation Type: A = B
        if actualType == "R1P1" {
            
            // Calculate reaction quotient
            if initialConcentrations[0] != 0.0 && initialConcentrations[1] != 0.0 {
                let numerator = initialConcentrations[1]
                let denominator = initialConcentrations[0]
                Q = numerator / denominator
            } else {
                Q = K
            }
            
            if initialConcentrations[1] == 0.0 {
                // Reactant A is nonzero: x = KA / (K + 1)
                let num = K * initialConcentrations[0]
                let den = K + 1
                x = num / den
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                
            } else if initialConcentrations[0] == 0.0 {
                // Reactant B is nonzero: x = B / (K + 1)
                let num = initialConcentrations[1]
                let den = K + 1
                x = num / den
                
                equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: decimalPlaces))
                
            } else if Q > K {
                // Q > K: x = (B - KA) / (K + 1)
                let num = initialConcentrations[1] - (K * initialConcentrations[0])
                let den = K + 1
                x = num / den
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] - x).rounded(toPlaces: decimalPlaces))
                
            } else if Q < K {
                // Q < K: x = (KA - B) / (K + 1)
                let num = (K * initialConcentrations[0]) - initialConcentrations[1]
                let den = K + 1
                x = num / den
                
                equilibriumConcentrations.append(Double(initialConcentrations[0] - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(initialConcentrations[1] + x).rounded(toPlaces: decimalPlaces))
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

