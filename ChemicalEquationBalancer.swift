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
    
    func getElements(input: String) {
        // remove whitespaces
        let equation = input.replacingOccurrences(of: " ", with: "")
        
        // separate both sides of equation
        let sides = equation.components(separatedBy: "=")
        
        // create array of reactants and products
        let reactants = sides[0].components(separatedBy: "+")
        let products = sides[1].components(separatedBy: "+")

    }
    
    func setupMatrices(coefficients: Int) {
        
    }
}
