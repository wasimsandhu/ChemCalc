//
//  ChemicalEquationBalancer.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/16/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import Foundation

class ChemicalEquationBalancer {
    
    var coefficients = [Int]()
    var dictionary: [String:Double] = [:]
    
    func getElements(input: String) {
        
        // remove whitespaces
        let equation = input.replacingOccurrences(of: " ", with: "")
        
        // separate both sides of equation
        let sides = equation.components(separatedBy: "=")
        
        // create array of reactants and products
        let reactants = sides[0].components(separatedBy: "+")
        let products = sides[1].components(separatedBy: "+")
        
        // get quantities of elements on both sides of equation
        let molarMassCalc = MolarMassCalculator()
        dictionary = molarMassCalc.createDictionary()
        
        for reactant in reactants {
            let molarMassOfReactant = molarMassCalc.calculate(compound: reactant)
            let elementsInReactant = molarMassCalc.getElementsInCompound()
            let quantitiesOfElementsInReactant = molarMassCalc.getNumberOfElements()
        }
        
        for product in products {
            let molarMassOfProduct = molarMassCalc.calculate(compound: product)
            let elementsInProduct = molarMassCalc.getElementsInCompound()
            let quantitiesOfElementsInProduct = molarMassCalc.getNumberOfElements()
        }
        
    }
    
    func setupMatrices(coefficients: Int) {
        
    }
}
