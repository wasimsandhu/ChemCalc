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
    var elementsInReaction = [String]()
    var quantitiesOfElementsInCompound = [Int]()
    var augmentedMatrix = [[Double]]()
    var coefficients = [Int]()
    
    // set up augmented matrix
    func setupMatrix(input: String) -> [Int] {
        
        // remove whitespaces
        let equation = input.replacingOccurrences(of: " ", with: "")
        
        // separate both sides of equation
        let sides = equation.components(separatedBy: "=")
        
        // create array of reactants and products
        let reactants = sides[0].components(separatedBy: "+")
        let products = sides[1].components(separatedBy: "+")
        
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
    
    func reduceToREF() {
        var lead = 0
        
        var rowCount = augmentedMatrix.count
        var columnCount = augmentedMatrix[0].count
        
        // move third column to other side of the equation
        if columnCount == 4 {
            var i = 0
            for row in augmentedMatrix {
                let fix = row[2] * -1
                augmentedMatrix[i][2] = fix
                i = i + 1
            }
        }
        
        // add implied row to matrix
        if columnCount == 4 && rowCount == 3 {
            augmentedMatrix.append([0,0,0,0])
        } else if columnCount == 3 && rowCount == 2 {
            augmentedMatrix.append([0,0,0])
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
        
        // TODO: fix up this bullshit LCM algorithm
        var multiplyByTwo = false
        var multiplyByThree = false
        var multiplyByFour = false
        var multiplyByFive = false
        var multiplyBySix = false
        var multiplyBySeven = false
        var multiplyByEight = false
        var multiplyByNine = false
        var multiplyByTen = false
        var multiply = false
        var numberToMultiplyBy: Double!
        
        for row in augmentedMatrix {
            for number in row {
                if number == 0.5 || number == 1.5 || number == 2.5 || number == 3.5 || number == 4.5 || number == 5.5 || number == 6.5 || number == 7.5 || number == 8.5 || number == 9.5 || number == 10.5 || number == 11.5 || number == 12.5 || number == 13.5 || number == 14.5 || number == 15.5 {
                    multiplyByTwo = true
                    multiply = true
                } else if number == 1.125 {
                    multiplyByEight = true
                    multiply = true
                }else if number == 0.25 {
                    multiplyByFour = true
                    multiply = true
                } else if number == 0.16666666666666666 {
                    multiplyBySix = true
                    multiply = true
                } else if number == 1.3 {
                    multiplyByTen = true
                    multiply = true
                }
            }
        }
        
        if multiply == true {
            if multiplyByTen == true {
                numberToMultiplyBy = 10
            } else if multiplyByEight == true {
                numberToMultiplyBy = 8
            } else if multiplyByTwo == true {
                numberToMultiplyBy = 2
            } else if multiplyByThree == true {
                numberToMultiplyBy = 3
            } else if multiplyByFour == true {
                numberToMultiplyBy = 4
            } else if multiplyBySix == true {
                numberToMultiplyBy = 6
            }
            
            var i = 0
            for row in augmentedMatrix {
                var j = 0
                for number in row {
                    augmentedMatrix[i][j] = augmentedMatrix[i][j] * numberToMultiplyBy
                    j = j + 1
                }
                i = i + 1
            }
        }
    }
    
    func getCoefficients() -> [Int] {
        
        for row in augmentedMatrix {
            let coefficient = Int(row.last!)
            coefficients.append(coefficient)
        }
        
        return coefficients
    }
}
