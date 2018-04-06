//
//  ChemicalEquationBalancer.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/16/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import Foundation

class ChemicalEquationBalancer {
    
    var compounds = [String]()
    var reactants = [String]()
    var products = [String]()
    
    var elementsInReaction = [String]()
    var quantitiesOfElementsInCompound = [Int]()
    var augmentedMatrix = [[Double]]()
    var lastColumn = [Double]()
    var coefficients = [Int]()
    
    // set up augmented matrix
    func setupMatrix(input: String) -> [Int] {
        
        // remove whitespaces
        let equation = input.replacingOccurrences(of: " ", with: "")
        
        // separate both sides of equation
        let sides = equation.components(separatedBy: "=")
        
        // create array of reactants and products
        reactants = sides[0].components(separatedBy: "+")
        products = sides[1].components(separatedBy: "+")
        
        // append both to compounds array
        for reactant in reactants { compounds.append(reactant) }
        for product in products { compounds.append(product) }
        
        // get quantities of elements on both sides of equation
        let molarMassCalc = MolarMassCalculator()
        
        // get total elements and total element quantities
        for compound in compounds {
            molarMassCalc.calculate(compound: compound)
            let elementsInCompound = molarMassCalc.getElementsInCompound()
            
            for element in elementsInCompound {
                if !elementsInReaction.contains(element) {
                    elementsInReaction.append(element)
                }
            }
        }
        
        // setup augmented matrix
        for element in elementsInReaction {
            var row = [Double]()
            
            for compound in compounds {
                molarMassCalc.calculate(compound: compound)
                let elementsAndQuantities = molarMassCalc.getElementsAndQuantities()
                if elementsAndQuantities[element] != nil {
                    row.append(Double(elementsAndQuantities[element]!))
                } else {
                    row.append(0)
                }
            }
            
            augmentedMatrix.append(row)
        }
        
        reduceToREF()
        let compoundCoefficients = getCoefficients()
        
        return compoundCoefficients
    }
    
    func getCompounds() -> [String] {
        return compounds
    }
    
    func getReactants() -> [String] {
        return reactants
    }
    
    func getProducts() -> [String] {
        return products
    }
    
    func reduceToREF() {
        var lead = 0
        
        var rowCount = augmentedMatrix.count
        var columnCount = augmentedMatrix[0].count
        
        // augment matrix
        if columnCount == 4 {
            var i = 0
            for row in augmentedMatrix {
                let fix = row[2] * -1
                augmentedMatrix[i][2] = fix
                i = i + 1
            }
        } else if columnCount == 5 {
            var z = 0
            if reactants.count == 2 && products.count == 3 {
                
                for row in augmentedMatrix {
                    if row[3] != 0.0 {
                        var fixx = row[3] * -1
                        augmentedMatrix[z][3] = fixx
                    }
                    z = z + 1
                }
                
                z = 0
                for row in augmentedMatrix {
                    if row[2] != 0.0 {
                        var fix = row[2] * -1
                        augmentedMatrix[z][2] = fix
                    }
                    z = z + 1
                }
                
            } else if reactants.count == 3 && products.count == 2 {
                for row in augmentedMatrix {
                    if row[3] != 0.0 {
                        let fixx = row[3] * -1
                        augmentedMatrix[z][3] = fixx
                        z = z + 1
                    }
                }
            }
        }
        
        // add implied row to matrix
        if columnCount == 4 && rowCount == 3 {
            augmentedMatrix.append([0,0,0,0])
        } else if columnCount == 3 && rowCount == 2 {
            augmentedMatrix.append([0,0,0])
        } else if columnCount == 2 && rowCount == 1 {
            augmentedMatrix.append([0,0])
        } else if columnCount == 5 && rowCount == 4 {
            augmentedMatrix.append([0,0,0,0,0])
        } else if columnCount == 6 && rowCount == 5 {
            augmentedMatrix.append([0,0,0,0,0,0])
        }
        
        // solve matrix https://rosettacode.org/wiki/Reduced_row_echelon_form#Swift
        for r in 0..<rowCount {
            if (columnCount <= lead) {
                break
            }
            var i = r
            while (augmentedMatrix[i][lead] == 0) {
                i = i + 1
                if (i == rowCount) {
                    i = r
                    lead = lead + 1
                    if (columnCount == lead) {
                        lead = lead - 1
                        break
                    }
                }
            }
            for j in 0..<columnCount {
                var temp = augmentedMatrix[r][j]
                augmentedMatrix[r][j] = augmentedMatrix[i][j]
                augmentedMatrix[i][j] = temp
            }
            var div = augmentedMatrix[r][lead]
            if (div != 0) {
                for j in 0..<columnCount {
                    augmentedMatrix[r][j] = augmentedMatrix[r][j] / div
                }
            }
            for j in 0..<rowCount {
                if (j != r) {
                    var sub = augmentedMatrix[j][lead]
                    for k in 0..<columnCount {
                        augmentedMatrix[j][k] = augmentedMatrix[j][k] - (sub * augmentedMatrix[r][k])
                    }
                }
            }
            lead = lead + 1
        }
        
        // fix negative numbers and zeroes in last column
        var anotherIndex = 0
        for row in augmentedMatrix {
            var coefficient = row.last
            
            if (coefficient! < 0) {
                coefficient = coefficient! * -1
                augmentedMatrix[anotherIndex][columnCount - 1] = coefficient!
            } else if coefficient == 0 {
                coefficient = 1
                augmentedMatrix[anotherIndex][columnCount - 1] = coefficient!
            } else {
                coefficient = row.last
            }
            
            anotherIndex = anotherIndex + 1
        }
    }
    
    /* FIND LCM OF LAST COLUMN FOR EQUATION COEFFICIENTS */
    // https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift
    typealias Rational = (num : Int, den : Int)
    
    func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
    // GCD of two numbers:
    func gcd(a: Int, b: Int) -> Int {
        var a = a
        var b = b
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return abs(a)
    }
    
    // GCD of a vector of numbers:
    func gcd(vector : [Int]) -> Int {
        return vector.reduce(0) { gcd(a: $0, b: $1) }
    }
    
    // LCM of two numbers:
    func lcm(a: Int, b: Int) -> Int {
        var b = b
        var a = a
        return (a / gcd(a: a, b: b)) * b
    }
    
    // LCM of a vector of numbers:
    func lcm(vector: [Int]) -> Int {
        return vector.reduce(1) { lcm(a: $0, b: $1) }
    }
    
    func simplifyRatios(numbers : [Double]) -> [Int] {
        // Normalize the input vector to that the maximum is 1.0,
        // and compute rational approximations of all components:
        let maximum = (numbers.map { abs($0) } ).max()
        let rats = numbers.map { rationalApproximationOf(x0: $0/maximum!) }
        
        // Multiply all rational numbers by the LCM of the denominators:
        let commonDenominator = lcm(vector: rats.map { $0.den })
        let numerators = rats.map { $0.num * commonDenominator / $0.den }
        
        // Divide the numerators by the GCD of all numerators:
        let commonNumerator = gcd(vector: numerators)
        return numerators.map { $0 / commonNumerator }
    }
    
    func getCoefficients() -> [Int] {
        
        for row in augmentedMatrix {
            let coefficient = row.last!
            lastColumn.append(coefficient)
        }
        
        coefficients = simplifyRatios(numbers: lastColumn)
        
        return coefficients
    }
}
