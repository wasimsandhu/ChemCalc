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
    var kRef: Double!
    
    var decimalPlaces = 4
    
    var actualType: String!
    
    var reactantA: Double!
    var reactantB: Double!
    var reactantC: Double!
    
    var productB: Double!
    var productC: Double!
    var productD: Double!
    
    var localCoefficients = [Int]()
    var localCompounds = [String]()
    var localConcentrations = [Double]()
    let xValuesToTry: [Double] = [-10, -7, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 7, 10]
    
    func solve(type: String, K: Double, compounds: [String], coefficients: [Int]) -> [Double] {
        
        // Resets solver variables
        zeroInDenominator = false
        reactionQuotientEqualsK = false
        localCompounds.removeAll()
        localCoefficients.removeAll()
        localConcentrations.removeAll()
        equilibriumConcentrations.removeAll()
        
        // Some class-level variables (because I'm lazy :P)
        kRef = K
        localCoefficients = coefficients
        localCompounds = compounds
        localConcentrations = initialConcentrations
        
        // TODO: Fix this, logic is flawed
        if type == "R2P2 SL1" || type == "R2P2 SL2" {
            actualType = "R1P2"
        } else if type == "R2P2 SL3" || type == "R2P2 SL4" {
            actualType = "R2P1"
        } else {
            actualType = type
        }
        
        // Reroute to proper calculation based on coefficients
        if type == "R1P1" {
            if coefficients[0] == 2 {
                // 2A = B
                actualType = "R1P1 2A"
            } else if coefficients[1] == 2 {
                // A = 2B
                actualType = "R1P1 2B"
            } else {
                actualType = type
            }
        } else if type == "R2P2" {
            if coefficients[0] == 2 && coefficients[2] == 2 ||
                coefficients[1] == 2 && coefficients[2] == 2 ||
                coefficients[1] == 2 && coefficients[3] == 2 ||
                coefficients[0] == 2 && coefficients[3] == 2 {
                    // A + 2B = C + 2D
                    actualType = "R2P2 A+2B=C+2D"
            } else {
                actualType = type
            }
        } else if type == "R2P1" {
            if coefficients[0] == 2 && coefficients[2] == 1 || coefficients[1] == 2 && coefficients[2] == 1 {
                // A + 2B = C
                actualType = "R2P1 A2+B=C"
                
            } else if coefficients[0] == 2 && coefficients[2] == 2 || coefficients[1] == 2 && coefficients[2] == 2 {
                // A + 2B = 2C
                actualType = "R2P1 A+2B=2C"
                
            } else if coefficients[0] == 1 && coefficients[1] == 1 && coefficients[2] == 2 {
                // A + B = 2C
                actualType = "R2P1 A+B=2C"
                
            } else if coefficients[0] == 1 && coefficients[1] == 3 && coefficients[2] == 2 ||
                        coefficients[0] == 3 && coefficients[1] == 1 && coefficients[2] == 2 {
                // A + 3B = 2C
                actualType = "R2P1 A+3B=2C"
                
            } else {
                actualType = type
            }
        } else if type == "R1P2" {
            if coefficients[0] == 2 && coefficients[1] == 2 && coefficients[2] == 1 ||
                coefficients[0] == 2 && coefficients[1] == 1 && coefficients[2] == 2 {
                // 2A = 2C + D
                actualType = "R1P2 2A=2C+D"
                
            } else if coefficients[0] == 2 && coefficients[1] == 3 && coefficients[2] == 1 ||
                        coefficients[0] == 2 && coefficients[1] == 1 && coefficients[2] == 3 {
                // 2A = 3B + C
                actualType = "R1P2 2A=3B+C"
                
            } else {
                actualType = type
            }
        }
                
        /// Equation Type: A + B = C
        if actualType == "R2P1" {
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            
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
        
        /// Equation Type: A + 2B = C
        if actualType == "R2P1 A2+B=C" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[0] == 2 {
                localCoefficients.rearrange(from: 0, to: 1)
                localCompounds.rearrange(from: 0, to: 1)
                localConcentrations.rearrange(from: 0, to: 1)
            }
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC
                let denominator = reactantA * reactantB * reactantB
                Q = numerator! / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                    
                    // AB^2K + 4ABKx + 4AKx^2 + B^2Kx + 4BKx^2 + 4Kx^3 - C + x
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEqualsC_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    
                    // AB^2K - 4ABKx + 4AKx^2 - B^2Kx + 4BKx^2 - 4Kx^3 - C - x
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEqualsC_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A + 2B = 2C
        if actualType == "R2P1 A+2B=2C" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[0] == 2 {
                localCoefficients.rearrange(from: 0, to: 1)
                localCompounds.rearrange(from: 0, to: 1)
                localConcentrations.rearrange(from: 0, to: 1)
            }
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productC
                let denominator = reactantA * reactantB * reactantB
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                    
                    // AB^{2}K + 4ABKx + 4AKx^{2} + B^{2}Kx + 4BKx^{2} + 4Kx^{3} - C^{2} + 4Cx - 4x^{2}
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEquals2C_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    
                    // AB^{2}K - 4ABKx + 4AKx^{2} - B^{2}Kx + 4BKx^{2} - 4Kx^{3} - C^{2} - 4Cx - 4x^{2}
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEquals2C_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A + B = 2C
        if actualType == "R2P1 A+B=2C" {
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productC
                let denominator = reactantA * reactantB
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlusBEquals2C_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                                        
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlusBEquals2C_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }

        /// Equation Type: A = C + D
        if actualType == "R1P2" {
            
            reactantA = localConcentrations[0]
            productC = localConcentrations[1]
            productD = localConcentrations[2]
            
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
        
        /// Equation Type: 2A = 2C + D
        if actualType == "R1P2 2A=2C+D" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[2] == 2 {
                localCoefficients.rearrange(from: 2, to: 1)
                localCompounds.rearrange(from: 2, to: 1)
                localConcentrations.rearrange(from: 2, to: 1)
            }
            
            reactantA = localConcentrations[0]
            productC = localConcentrations[1]
            productD = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                let numerator = productC * productC * productD
                let denominator = reactantA * reactantA
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q > K {
                                        
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: f2AEquals2CPlusD_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                                        
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: f2AEquals2CPlusD_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Equation Type: A = B
        if actualType == "R1P1" {
            
            reactantA = localConcentrations[0]
            productB = localConcentrations[1]
            
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
            
            reactantA = localConcentrations[0]
            productB = localConcentrations[1]
            
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
            
            reactantA = localConcentrations[0]
            productB = localConcentrations[1]
            
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
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            productD = localConcentrations[3]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productD
                let denominator = reactantA * reactantB
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
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
        }
        
        /// Equation Type: A + 2B = C + 2D
        if actualType == "R2P2 A+2B=C+2D" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[0] == 2 {
                localCoefficients.rearrange(from: 0, to: 1)
                localCompounds.rearrange(from: 0, to: 1)
                localConcentrations.rearrange(from: 0, to: 1)
            }
            
            if coefficients[2] == 2 {
                localCoefficients.rearrange(from: 2, to: 3)
                localCompounds.rearrange(from: 2, to: 3)
                localConcentrations.rearrange(from: 2, to: 3)
            }
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            productD = localConcentrations[3]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productD * productD
                let denominator = reactantA * reactantB * reactantB
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                if Q < K {
                    
                    // AKB^2 - 4ABKx + 4AKx^2 - KxB^2 + 4BKx^2 - 4Kx^3 - CD^2 - xD^2 - 4CDx - 4x^2D - 4x^2C - 4x^3
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEqualsCPlus2D_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD + 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q > K {
                    
                    // AKB^2 + 4ABKx + 4AKx^2 + KxB^2 + 4BKx^2 + 4Kx^3 - CD^2 + xD^2 + 4CDx - 4x^2D - 4x^2C + 4x^3
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus2BEqualsCPlus2D_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            x = answer
                        } else {
                            // Error message
                            x = 0
                        }
                    }
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productD - 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
        
        /// Ammonia Synthesis: A + 3B = 2C
        if actualType == "R2P1 A+3B=2C" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[0] == 3 {
                localCoefficients.rearrange(from: 0, to: 1)
                localCompounds.rearrange(from: 0, to: 1)
                localConcentrations.rearrange(from: 0, to: 1)
            }
            
            reactantA = localConcentrations[0]
            reactantB = localConcentrations[1]
            productC = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 && reactantB != 0.0 {
                let numerator = productC * productC
                let denominator = reactantA * reactantB * reactantB * reactantB
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                
                var allXValues = [Double]()
                                
                if Q > K {
                                        
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus3BEquals2C_QGreaterThanK,
                                                   derivativeOfTheFunction: dfAPlus3BEquals2C_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            allXValues.append(answer)
                        } else {
                            // Error message
                            allXValues.append(0)
                        }
                    }
                    
                    var absoluteValueOfXValues = [Double]()
                    
                    for xValue in allXValues {
                        absoluteValueOfXValues.append(abs(xValue))
                    }
                    
                    x = absoluteValueOfXValues.min()
                    
                    equilibriumConcentrations.append(Double(reactantA + x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB + 3*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: fAPlus3BEquals2C_QLessThanK,
                                                   derivativeOfTheFunction: dfAPlus3BEquals2C_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            allXValues.append(answer)
                        } else {
                            // Error message
                            allXValues.append(0)
                        }
                    }
                    
                    var absoluteValueOfXValues = [Double]()
                    
                    for xValue in allXValues {
                        absoluteValueOfXValues.append(abs(xValue))
                    }
                    
                    x = absoluteValueOfXValues.min()
                    
                    equilibriumConcentrations.append(Double(reactantA - x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(reactantB - 3*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + 2*x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
            }
        }
    
        /// Ammonia Decomposition: 2A = 3B + C
        if actualType == "R1P2 2A=3B+C" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[2] == 3 {
                localCoefficients.rearrange(from: 2, to: 1)
                localCompounds.rearrange(from: 2, to: 1)
                localConcentrations.rearrange(from: 2, to: 1)
            }
            
            reactantA = localConcentrations[0]
            productB = localConcentrations[1]
            productC = localConcentrations[2]
            
            // Calculate reaction quotient
            if reactantA != 0.0 {
                let productBCubed = productB * productB * productB
                let numerator = productBCubed * productC
                let denominator = reactantA * reactantA
                Q = numerator / denominator
            } else {
                zeroInDenominator = true
            }
            
            if !zeroInDenominator {
                
                var allXValues = [Double]()
                                
                if Q > K {
                                        
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: f2AEquals3BPlusC_QGreaterThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            allXValues.append(answer)
                        } else {
                            // Error message
                            allXValues.append(0)
                        }
                    }
                    
                    var absoluteValueOfXValues = [Double]()
                    
                    for xValue in allXValues {
                        absoluteValueOfXValues.append(abs(xValue))
                    }
                    
                    x = absoluteValueOfXValues.min()
                    
                    equilibriumConcentrations.append(Double(reactantA + 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB - 3*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC - x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q < K {
                    
                    for X in xValuesToTry {
                        let newton = NewtonRaphson(functionToFindRootsOf: f2AEquals3BPlusC_QLessThanK,
                                                   initialGuessForX: X,
                                                   tolerance: 0.00005,
                                                   maxIterations: 100)
                        
                        if let answer = newton.solve() {
                            allXValues.append(answer)
                        } else {
                            // Error message
                            allXValues.append(0)
                        }
                    }
                    
                    var absoluteValueOfXValues = [Double]()
                    
                    for xValue in allXValues {
                        absoluteValueOfXValues.append(abs(xValue))
                    }
                    
                    x = absoluteValueOfXValues.min()
                    
                    equilibriumConcentrations.append(Double(reactantA - 2*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productB + 3*x).rounded(toPlaces: decimalPlaces))
                    equilibriumConcentrations.append(Double(productC + x).rounded(toPlaces: decimalPlaces))
                    
                } else if Q == K {
                    reactionQuotientEqualsK = true
                }
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
        
    // Polynomial for equation type A + 2B = C + 2D
    func fAPlus2BEqualsCPlus2D_QLessThanK(_ X: Double) -> Double {
        
        // AKB^2 - 4ABKx + 4AKx^2 - KxB^2 + 4BKx^2 - 4Kx^3 - CD^2 - xD^2 - 4CDx - 4x^2D - 4x^2C - 4x^3
        let term1 = reactantA * kRef * reactantB * reactantB
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = kRef * X * reactantB * reactantB
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = productC * productD * productD
        let term8 = X * productD * productD
        let term9 = 4 * productC * productD * X
        let term10 = 4 * pow(X, 2) * productD
        let term11 = 4 * pow(X, 2) * productC
        let term12 = 4 * pow(X, 3)
        
        return term1 - term2 + term3 - term4 + term5 - term6 - term7 - term8 - term9 - term10 - term11 - term12
    }
    
    func fAPlus2BEqualsCPlus2D_QGreaterThanK(_ X: Double) -> Double {
        
        // AKB^2 + 4ABKx + 4AKx^2 + KxB^2 + 4BKx^2 + 4Kx^3 - CD^2 + xD^2 + 4CDx - 4x^2D - 4x^2C + 4x^3
        let term1 = reactantA * kRef * reactantB * reactantB
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = kRef * X * reactantB * reactantB
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = productC * productD * productD
        let term8 = X * productD * productD
        let term9 = 4 * productC * productD * X
        let term10 = 4 * pow(X, 2) * productD
        let term11 = 4 * pow(X, 2) * productC
        let term12 = 4 * pow(X, 3)
        
        return term1 + term2 + term3 + term4 + term5 + term6 - term7 + term8 + term9 - term10 - term11 + term12
    }
    
    // Polynomial for equation type A + 2B = C
    func fAPlus2BEqualsC_QGreaterThanK(_ X: Double) -> Double {
        
        // AB^2K + 4ABKx + 4AKx^2 + B^2Kx + 4BKx^2 + 4Kx^3 - C + x
        let term1 = reactantA * reactantB * reactantB * kRef
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = reactantB * reactantB * kRef * X
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = -productC + X
        
        return term1 + term2 + term3 + term4 + term5 + term6 + term7
    }
    
    func fAPlus2BEqualsC_QLessThanK(_ X: Double) -> Double {
        
        // AB^2K - 4ABKx + 4AKx^2 - B^2Kx + 4BKx^2 - 4Kx^3 - C - x
        let term1 = reactantA * reactantB * reactantB * kRef
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = reactantB * reactantB * kRef * X
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = -productC - X
        
        return term1 - term2 + term3 - term4 + term5 - term6 + term7
    }
    
    // Polynomial for equation type A + 2B = 2C
    func fAPlus2BEquals2C_QGreaterThanK(_ X: Double) -> Double {
        
        // AB^{2}K + 4ABKx + 4AKx^{2} + B^{2}Kx + 4BKx^{2} + 4Kx^{3} - C^{2} + 4Cx - 4x^{2}
        let term1 = reactantA * reactantB * reactantB * kRef
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = reactantB * reactantB * kRef * X
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = productC * productC
        let term8 = 4 * productC * X
        let term9 = 4 * pow(X, 2)

        let total = term1 + term2 + term3 + term4 + term5 + term6 - term7 + term8 - term9
        return total
    }
    
    func fAPlus2BEquals2C_QLessThanK(_ X: Double) -> Double {
    
        // AB^{2}K - 4ABKx + 4AKx^{2} - B^{2}Kx + 4BKx^{2} - 4Kx^{3} - C^{2} - 4Cx - 4x^{2}
        let term1 = reactantA * reactantB * reactantB * kRef
        let term2 = 4 * reactantA * reactantB * kRef * X
        let term3 = 4 * reactantA * kRef * pow(X, 2)
        let term4 = reactantB * reactantB * kRef * X
        let term5 = 4 * reactantB * kRef * pow(X, 2)
        let term6 = 4 * kRef * pow(X, 3)
        let term7 = productC * productC
        let term8 = 4 * productC * X
        let term9 = 4 * pow(X, 2)
        
        let total = term1 - term2 + term3 - term4 + term5 - term6 - term7 - term8 - term9
        return total
    }
    
    func f2AEquals2CPlusD_QGreaterThanK(_ X: Double) -> Double {
        
        // KA^{2} + 4AKx + 4Kx^{2} - C^{2}D + xC^{2} + 4CDx - 4Cx^{2} - 4x^{2}D + 4x^{3}
        let term1 = kRef * reactantA * reactantA
        let term2 = 4 * reactantA * kRef * X
        let term3 = 4 * kRef * pow(X, 2)
        let term4 = productC * productC * productD
        let term5 = X * productC * productC
        let term6 = 4 * productC * productD * X
        let term7 = 4 * productC * pow(X, 2)
        let term8 = 4 * pow(X, 2) * productD
        let term9 = 4 * pow(X, 3)
        
        let total = term1 + term2 + term3 - term4 + term5 + term6 - term7 - term8 + term9
        return total
    }
    
    func f2AEquals2CPlusD_QLessThanK(_ X: Double) -> Double {
        
        // KA^{2} - 4AKx + 4Kx^{2} - C^{2}D - xC^{2} - 4CDx - 4Cx^{2} - 4x^{2}D - 4x^{3}
        let term1 = kRef * reactantA * reactantA
        let term2 = 4 * reactantA * kRef * X
        let term3 = 4 * kRef * pow(X, 2)
        let term4 = productC * productC * productD
        let term5 = X * productC * productC
        let term6 = 4 * productC * productD * X
        let term7 = 4 * productC * pow(X, 2)
        let term8 = 4 * pow(X, 2) * productD
        let term9 = 4 * pow(X, 3)
        
        let total = term1 - term2 + term3 - term4 - term5 - term6 - term7 - term8 - term9
        return total
    }
    
    func fAPlusBEquals2C_QGreaterThanK(_ X: Double) -> Double {
        
        // ABK + AKx + BKx + Kx^{2} - C^{2} + 4Cx - 4x^{2}
        let term1 = reactantA * reactantB * kRef
        let term2 = reactantA * kRef * X
        let term3 = reactantB * kRef * X
        let term4 = kRef * pow(X, 2)
        let term5 = productC * productC
        let term6 = 4 * productC * X
        let term7 = 4 * pow(X, 2)
        
        let total = term1 + term2 + term3 + term4 - term5 + term6 - term7
        return total
    }
    
    func fAPlusBEquals2C_QLessThanK(_ X: Double) -> Double {
        
        // ABK - AKx - BKx + Kx^{2} - C^{2} - 4Cx - 4x^{2}
        let term1 = reactantA * reactantB * kRef
        let term2 = reactantA * kRef * X
        let term3 = reactantB * kRef * X
        let term4 = kRef * pow(X, 2)
        let term5 = productC * productC
        let term6 = 4 * productC * X
        let term7 = 4 * pow(X, 2)
        
        let total = term1 - term2 - term3 + term4 - term5 - term6 - term7
        return total
    }
    
    // Polynomial functions and derivatives for equation type A + 3B = 2C
    func fAPlus3BEquals2C_QGreaterThanK(_ X: Double) -> Double {
        
        let reactantBSquared = reactantB * reactantB
        let reactantBCubed = reactantB * reactantB * reactantB
        
        let term1 = reactantA * reactantBCubed * kRef
        let term2 = 9 * reactantA * reactantBSquared * kRef * X
        let term3 = 27 * reactantA * reactantB * kRef * pow(X, 2)
        let term4 = 27 * reactantA * kRef * pow(X, 3)
        let term5 = reactantB * reactantB * reactantB * kRef * X
        let term6 = 9 * reactantB * reactantB * kRef * pow(X, 2)
        let term7 = 27 * reactantB * kRef * pow(X, 3)
        let term8 = 27 * kRef * pow(X, 4)
        let term9 = productC * productC
        let term10 = 4 * productC * X
        let term11 = 4 * pow(X, 2)
        
        // AB^{3}K + 9AB^{2}Kx + 27ABKx^{2} + 27AKx^{3} + B^{3}Kx + 9B^{2}Kx^{2} + 27BKx^{3} + 27Kx^{4} - C^{2} + 4Cx - 4x^{2}
        let total = term1 + term2 + term3 + term4 + term5 + term6 + term7 + term8 - term9 + term10 - term11
        return total
    }
    
    func fAPlus3BEquals2C_QLessThanK(_ X: Double) -> Double {
        
        let reactantBSquared = reactantB * reactantB
        let reactantBCubed = reactantB * reactantB * reactantB
        
        let term1 = reactantA * reactantBCubed * kRef
        let term2 = 9 * reactantA * reactantBSquared * kRef * X
        let term3 = 27 * reactantA * reactantB * kRef * pow(X, 2)
        let term4 = 27 * reactantA * kRef * pow(X, 3)
        let term5 = reactantBCubed * kRef * X
        let term6 = 9 * reactantBSquared * kRef * pow(X, 2)
        let term7 = 27 * reactantB * kRef * pow(X, 3)
        let term8 = 27 * kRef * pow(X, 4)
        let term9 = productC * productC
        let term10 = 4 * productC * X
        let term11 = 4 * pow(X, 2)
        
        // AB^{3}K - 9AB^{2}Kx + 27ABKx^{2} - 27AKx^{3} - B^{3}Kx + 9B^{2}Kx^{2} - 27BKx^{3} + 27Kx^{4} - C^{2} - 4Cx - 4x^{2}
        let total = term1 - term2 + term3 - term4 - term5 + term6 - term7 + term8 - term9 - term10 - term11
        return total
    }
    
    func dfAPlus3BEquals2C_QGreaterThanK(_ X: Double) -> Double {
        
        let reactantBSquared = reactantB * reactantB
        let reactantBCubed = reactantB * reactantB * reactantB
        
        let term1 = 108 * kRef * pow(X, 3)
        let term2 = 81 * reactantB * kRef * pow(X, 2)
        let term3 = 81 * reactantA * kRef * pow(X, 2)
        let term4 = 18 * reactantBSquared * kRef * X
        let term5 = 54 * reactantA * reactantB * kRef * X
        let term6 = 8 * X
        let term7 = reactantBCubed * kRef
        let term8 = 9 * reactantA * reactantBSquared * kRef
        let term9 = 4 * productC
        
        // 108Kx^{3} + 81BKx^{2} + 81AKx^{2} + 18B^{2}Kx + 54ABKx - 8x + B^{3}K + 9AB^{2}K + 4C
        let total = term1 + term2 + term3 + term4 + term5 - term6 + term7 + term8 + term9
        return total
    }
    
    func dfAPlus3BEquals2C_QLessThanK(_ X: Double) -> Double {
        let reactantBSquared = reactantB * reactantB
        let reactantBCubed = reactantB * reactantB * reactantB
        
        let term1 = 108 * kRef * pow(X, 3)
        let term2 = 81 * reactantB * kRef * pow(X, 2)
        let term3 = 81 * reactantA * kRef * pow(X, 2)
        let term4 = 18 * reactantBSquared * kRef * X
        let term5 = 54 * reactantA * reactantB * kRef * X
        let term6 = 8 * X
        let term7 = reactantBCubed * kRef
        let term8 = 9 * reactantA * reactantBSquared * kRef
        let term9 = 4 * productC
        
        // 108Kx^{3} - 81BKx^{2} - 81AKx^{2} + 18B^{2}Kx + 54ABKx - 8x - B^{3}K - 9AB^{2}K - 4C
        let total = term1 - term2 - term3 + term4 + term5 - term6 - term7 - term8 - term9
        return total
    }
    
    func f2AEquals3BPlusC_QGreaterThanK(_ X: Double) -> Double {
        
        let productBSquared = productB * productB
        let productBCubed = productB * productB * productB
        
        let term1 = kRef * reactantA * reactantA
        let term2 = 4 * reactantA * kRef * X
        let term3 = 4 * kRef * pow(X, 2)
        let term4 = productBCubed * productC
        let term5 = X * productBCubed
        let term6 = 9 * X * productBSquared * productC
        let term7 = 9 * pow(X, 2) * productBSquared
        let term8 = 27 * productB * pow(X, 2) * productC
        let term9 = 27 * productB * pow(X, 3)
        let term10 = 27 * pow(X, 3) * productC
        let term11 = 27 * pow(X, 4)
        
        // KA^{2} + 4AKx + 4Kx^{2} - B^{3}C + xB^{3} + 9xB^{2}C - 9x^{2}B^{2} - 27Bx^{2}C + 27Bx^{3} + 27x^{3}C - 27x^{4}
        let total = term1 + term2 + term3 - term4 + term5 + term6 - term7 - term8 + term9 + term10 - term11
        
        return total
    }
    
    func f2AEquals3BPlusC_QLessThanK(_ X: Double) -> Double {
        
        let productBSquared = productB * productB
        let productBCubed = productB * productB * productB
        
        let term1 = kRef * reactantA * reactantA
        let term2 = 4 * reactantA * kRef * X
        let term3 = 4 * kRef * pow(X, 2)
        let term4 = productBCubed * productC
        let term5 = X * productBCubed
        let term6 = 9 * X * productBSquared * productC
        let term7 = 9 * pow(X, 2) * productBSquared
        let term8 = 27 * productB * pow(X, 2) * productC
        let term9 = 27 * productB * pow(X, 3)
        let term10 = 27 * pow(X, 3) * productC
        let term11 = 27 * pow(X, 4)
        
        // KA^{2} - 4AKx + 4Kx^{2} - B^{3}C - xB^{3} - 9xB^{2}C - 9x^{2}B^{2} - 27Bx^{2}C - 27Bx^{3} - 27x^{3}C - 27x^{4}
        let total = term1 - term2 + term3 - term4 - term5 - term6 - term7 - term8 - term9 - term10 - term11
        
        return total
    }
    
}

// Newton-Raphson by jamesharrop https://github.com/jamesharrop/newton-raphson
// A Swift implementation of the Newton-Raphson method for finding the roots of a mathematical function.

class NewtonRaphson {
    let functionToFindRootsOf: (Double)->Double
    let derivativeOfTheFunction: (Double) -> Double
    let initialGuessForX: Double
    let tolerance: Double
    let maxIterations: Int
    
    // Init if the derivative of the function is provided
    init(functionToFindRootsOf: @escaping (Double)->Double, derivativeOfTheFunction: @escaping (Double) -> Double, initialGuessForX: Double, tolerance: Double, maxIterations: Int) {
        self.functionToFindRootsOf = functionToFindRootsOf
        self.derivativeOfTheFunction = derivativeOfTheFunction
        self.initialGuessForX = initialGuessForX
        self.tolerance = tolerance
        self.maxIterations = maxIterations
    }
    
    // Init if the derivative of the function is not provided - we will approximate the derivative instead
    init(functionToFindRootsOf: @escaping (Double)->Double, initialGuessForX: Double, tolerance: Double, maxIterations: Int) {
        self.functionToFindRootsOf = functionToFindRootsOf
        self.derivativeOfTheFunction = {
            (x:Double) in
            return (functionToFindRootsOf(x+tolerance/5) - functionToFindRootsOf(x-tolerance/5)) / (2*(tolerance/5)) }
        self.initialGuessForX = initialGuessForX
        self.tolerance = tolerance
        self.maxIterations = maxIterations
    }
    
    func solve() -> Double? {
        // If maxIterations is exceeded before a solution within the tolerance is found, then returns nil
        var x = self.initialGuessForX
        for iteration in 1...maxIterations {
            let y = self.functionToFindRootsOf(x)
            let dy = self.derivativeOfTheFunction(x)
            let nextX = x - y / dy
            if (abs(x - nextX) < self.tolerance) {
                print("Solution reached in ", iteration, "iterations")
                print(nextX)
                return nextX
            }
            x = nextX
        }
        return nil
    }
}

// Rounds the double to decimal places value
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// Array rearrangement
extension RangeReplaceableCollection where Indices: Equatable {
    mutating func rearrange(from: Index, to: Index) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indices")
        insert(remove(at: from), at: to)
    }
}
