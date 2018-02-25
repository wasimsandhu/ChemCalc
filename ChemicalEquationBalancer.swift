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
    var augmentedMatrix = [[Int]]()
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
            var row = [Int]()
            
            for compound in compounds {
                molarMassCalc.calculate(compound: compound)
                let elementsAndQuantities = molarMassCalc.getElementsAndQuantities()
                if elementsAndQuantities[element] != nil {
                    row.append(elementsAndQuantities[element]!)
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
        
        if rowCount < columnCount {
            if rowCount == 3 && columnCount == 4 {
                augmentedMatrix.append([0,0,0,1])
            } else if rowCount == 2 && columnCount == 3 {
                augmentedMatrix.append([0,0,1])
            }
            
            rowCount = augmentedMatrix.count
            columnCount = augmentedMatrix[0].count
        }
        
        /* print("Rows: " + String(rowCount))
        print("Columns: " + String(columnCount)) */
        
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
    }
    
    func getCoefficients() -> [Int] {
        
        for row in augmentedMatrix {
            
            var coefficient = row.last
            
            if (coefficient! < 0) {
                coefficient = coefficient! * -1
            } else if coefficient == 0 {
                coefficient = 1
            }
            
            coefficients.append(coefficient!)
        }
        
        return coefficients
    }
}
