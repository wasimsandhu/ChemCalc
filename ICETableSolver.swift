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
    
    func solve(type: String, K: Double, compounds: [String], coefficients: [Int]) -> [Double] {
        
        // Resets solver variables
        zeroInDenominator = false
        reactionQuotientEqualsK = false
        equilibriumConcentrations.removeAll()
        
        // Some class-level variables (because I'm lazy :P)
        kRef = K
        localCoefficients = coefficients
        localCompounds = compounds
        
        // Simplify equation types
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
                actualType = "R1P1 2A"  // 2A = B
            } else if coefficients[1] == 2 {
                actualType = "R1P1 2B"  // A = 2B
            }
        } else if type == "R2P2" {
            if coefficients[0] == 2 && coefficients[2] == 2 ||
                coefficients[1] == 2 && coefficients[2] == 2 ||
                coefficients[1] == 2 && coefficients[3] == 2 ||
                coefficients[0] == 2 && coefficients[3] == 2 {
                    actualType = "R2P2 A2B=C2D"    // A + 2B = C + 2D
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
        if actualType == "R2P2 A2B=C2D" {
            
            // Rearranging to put coefficients in correct place
            if coefficients[0] == 2 {
                localCoefficients.rearrange(from: 0, to: 1)
                localCompounds.rearrange(from: 0, to: 1)
                initialConcentrations.rearrange(from: 0, to: 1)
            }
            
            if coefficients[2] == 2 {
                localCoefficients.rearrange(from: 2, to: 3)
                localCompounds.rearrange(from: 2, to: 3)
                initialConcentrations.rearrange(from: 2, to: 3)
            }
            
            reactantA = initialConcentrations[0]
            reactantB = initialConcentrations[1]
            productC = initialConcentrations[2]
            productD = initialConcentrations[3]
            
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
                    let xValuesToTry: [Double] = [0, 1, 3, 5, 7, 10]
                    
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
                    let xValuesToTry: [Double] = [0, 1, 3, 5, 7, 10]
                    
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
        
    // Reaction Type A + 2B = C + 2D – if Q < K
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
    
    // Reaction Type A + 2B = C + 2D – if Q > K
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
