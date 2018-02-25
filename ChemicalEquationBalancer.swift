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
    
    // set up augmented matrix
    func getElements(input: String) {
        
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
        
        reduceToREF(matrix: augmentedMatrix)
    }
    
    func reduceToREF(matrix: [[Int]]) {
        
    }
}
