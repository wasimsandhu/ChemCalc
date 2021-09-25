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
var zeroInDenominator = false
var reactionQuotientEqualsK = false

class ICETableSolver {
    
    var a: Double!
    var b: Double!
    var c: Double!
    var x: Double!
    var Q: Double!
    
    var decimalPlaces = 4
    
    var actualType: String!
    
    var reactantA: Double!
    var reactantB: Double!
    var reactantC: Double!
    
    var productB: Double!
    var productC: Double!
    var productD: Double!
    
    func solve(type: String, K: Double, compounds: [String], coefficients: [Int]) -> [Double] {
        
        zeroInDenominator = false
        reactionQuotientEqualsK = false
        equilibriumConcentrations.removeAll()
        
        // Simplify equation types
        if type == "R2P2 SL1" || type == "R2P2 SL2" {
            actualType = "R1P2"
        } else if type == "R2P2 SL3" || type == "R2P2 SL4" {
            actualType = "R2P1"
        } else {
            actualType = type
        }
        
        if type == "R1P1" {
            if coefficients[0] == 2 {
                actualType = "R1P1 2A"
            } else if coefficients[1] == 2 {
                actualType = "R1P1 2B"
            }
        } else {
            actualType = type
        }
                
        /// Equation Type: A + B = C
        if actualType == "R2P1" {
            
            reactantA = initialConcentrations[0]
            reactantB = initialConcentrations[1]
            productC = initialConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC
                let denominator = reactantA * reactantB
                Q = numerator! / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q < K {
                    // Q < K: Kx^2 + (-KA-KB-1)x + KAB-C = 0
                    a = K
                    b = -K * reactantA - K * reactantB - 1
                    c = K * reactantA * reactantB - productC
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q > K {
                    // Q > K: Kx^2 + (KA+KB+1)x + KAB-C = 0
                    a = K
                    b = K * reactantA + K * reactantB + 1
                    c = K * reactantA * reactantB - productC
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    
                } else if initialConcentrations[2] == 0.0 {
                    // Reactants A and B are nonzero: Kx^2 + (-KA-KB-1)x + KAB = 0
                    a = K
                    b = -K * reactantA - K * reactantB - 1
                    c = K * reactantA * reactantB
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                    
                } else if initialConcentrations[2] != 0.0 {
                    // Product C is nonzero: Kx^2 + x - C = 0
                    a = K
                    b = 1
                    c = -1 * productC
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A = C + D
        if actualType == "R1P2" {
            
            reactantA = initialConcentrations[0]
            productC = initialConcentrations[1]
            productD = initialConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                let numerator = productC * productD
                Q = numerator / reactantA
            } else if Q == K {
                reactionQuotientEqualsK = true
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q < K {
                    // x^2 + (C+D+K)x + CD-KA = 0

                    a = 1
                    
                    b = productC + productD + K
                    
                    let csum1 = productC * productD
                    let csum2 = K * reactantA
                    c = csum1 - csum2
                    
                    x = solveQuadraticEquation(a: a, b: b, c: c)

                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q > K {
                    // x^2 + (-C-D-K)x + CD-KA = 0

                    a = 1
                    
                    b = -productC - productD - K
                    
                    let csum1 = productC * productD
                    let csum2 = K * reactantA
                    c = csum1 - csum2
                    
                    x = solveQuadraticEquation(a: a, b: b, c: c)

                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A = B
        if actualType == "R1P1" {
            
            reactantA = initialConcentrations[0]
            productB = initialConcentrations[1]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                Q = reactantB / reactantA
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if productB == 0.0 {
                    // Reactant A is nonzero: x = KA / (K + 1)
                    let num = K * reactantA
                    let den = K + 1
                    x = num / den
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                    
                } else if reactantA == 0.0 {
                    // Reactant B is nonzero: x = B / (K + 1)
                    let num = productB
                    let den = K + 1
                    x = num! / den
                    
                    equilibriumConcentrations.append(Double(x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q > K {
                    // Q > K: x = (B - KA) / (K + 1)
                    let num = productB - (K * reactantA)
                    let den = K + 1
                    x = num / den
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    // Q < K: x = (KA - B) / (K + 1)
                    let num = (K * reactantA) - productB
                    let den = K + 1
                    x = num / den
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: 2A = B
        if actualType == "R1P1 2A" {
            
            reactantA = initialConcentrations[0]
            productB = initialConcentrations[1]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                let reactantASquared = reactantA * reactantA
                Q = productB / reactantASquared
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                    // x^2(4K) + x(4KA+1) + KA^2-B = 0
                    
                    a = 4*K
                    b = 4*K*reactantA + 1
                    let csum1 = K*reactantA*reactantA
                    c = csum1 - productB
                    x = solveQuadraticEquation(a: a, b: b, c: c)

                    equilibriumConcentrations.append(Double(reactantA + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    // x^2(4K) + x(-4KA-1) + KA^2-B = 0
                    
                    a = 4*K
                    b = -4*K*reactantA - 1
                    let csum1 = K*reactantA*reactantA
                    c = csum1 - productB
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(reactantA - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A = 2B
        if actualType == "R1P1 2B" {
            
            reactantA = initialConcentrations[0]
            productB = initialConcentrations[1]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                let productBSquared = productB * productB
                Q = productBSquared / reactantA
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                    // 4x^2 + x(-4B-K) + B^2-KA = 0
                    
                    a = 4
                    b = -4*productB - K
                    let bSquared = productB * productB
                    c = bSquared - K*reactantA
                    x = solveQuadraticEquation(a: a, b: b, c: c)

                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB - 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    // 4x^2 + x(4B+K) + B^2-KA = 0

                    a = 4
                    b = 4*productB + K
                    let bSquared = productB * productB
                    c = bSquared - K*reactantA
                    x = solveQuadraticEquation(a: a, b: b, c: c)
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB + 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
            
        }
        
        /// Equation Type: A + B = C + D
        if actualType == "R2P2" {
            
            reactantA = initialConcentrations[0]
            reactantB = initialConcentrations[1]
            productC = initialConcentrations[2]
            productD = initialConcentrations[3]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productD
                let denominator = reactantA * reactantB
                Q = numerator / denominator
            } else if Q == K {
                reactionQuotientEqualsK = true
            } else {
                zeroInDenominator = true
            }
            
            if Q < K {
                
                // x^2(1-K) + x(C+D+KA+KB) + CD-KAB = 0
                a = 1 - K
                
                let bsum1 = productC + productD
                let bsum2 = K*reactantA + K*reactantB
                b = bsum1 + bsum2
                
                let csum1 = productC * productD
                let csum2 = K * reactantA * reactantB
                c = csum1 - csum2
                
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(reactantB - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(productD + x).rounded(toPlaces: decimalPlaces))
                
            } else if Q > K {
                
                // x^2(1-K) + x(-C-D-KA-KB) + CD-KAB = 0
                a = 1 - K
                
                let bsum1 = -productC - productD
                let bsum2 = K*reactantA
                let bsum3 = K*reactantB
                b = bsum1 - bsum2 - bsum3
                
                let csum1 = productC * productD
                let csum2 = K * reactantA * reactantB
                c = csum1 - csum2
                
                x = solveQuadraticEquation(a: a, b: b, c: c)
                
                equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(reactantB + x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                equilibriumConcentrations.append(Double(productD - x).rounded(toPlaces: decimalPlaces))
                
            } else if Q == K {
                reactionQuotientEqualsK = true
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

