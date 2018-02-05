//
//  Stoichiometry.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/31/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import Foundation

class Stoichiometry {
    
    var limitingReactant: String?
    var limitingReactantAmount: Double?
    var limitingReactantMolarMass: Double?
    var limitingReactantCoefficient: Int?
    
    var excessReactant: String?
    var excessReactantUsed: Double?
    var excessReactantLeft: Double?
    
    var theoreticalYield: Double?
    
    func getLimitingReactant(reactant1: String, amount1: Double, coefficient1: Int, reactant2: String, amount2: Double, coefficient2: Int) -> String {
        
        let molarMassOfFirstReactant = MolarMassCalculator().calculate(compound: reactant1)
        let molarMassOfSecondReactant = MolarMassCalculator().calculate(compound: reactant2)
        
        let amountOfSecondReactantNeeded = (amount1 / molarMassOfFirstReactant) * (Double(coefficient2) / Double(coefficient1)) * molarMassOfSecondReactant
        
        if amountOfSecondReactantNeeded > amount2 {
            limitingReactant = reactant2
            
            limitingReactantAmount = amount2
            limitingReactantMolarMass = molarMassOfSecondReactant
            limitingReactantCoefficient = coefficient2
            
            excessReactantUsed = (amount2 / molarMassOfSecondReactant) * (Double(coefficient1) / Double(coefficient2)) * molarMassOfFirstReactant
            
            excessReactantLeft = amount1 - excessReactantUsed!
            
        } else if amountOfSecondReactantNeeded < amount2 {
            limitingReactant = reactant1
            
            limitingReactantAmount = amount1
            limitingReactantMolarMass = molarMassOfFirstReactant
            limitingReactantCoefficient = coefficient1
            
            excessReactantUsed = (amount1 / molarMassOfFirstReactant) * (Double(coefficient2) / Double(coefficient1)) * molarMassOfSecondReactant
            
            excessReactantLeft = amount2 - excessReactantUsed!
        }
        
        return limitingReactant!
    }
    
    func getExcessReactant() -> Double {
        return excessReactantLeft!
    }
    
    // for calculating theoretical yield
    func getTheoreticalYield(product: String, productCoefficient: Int) -> Double {
        
        let molarMassOfProduct = MolarMassCalculator().calculate(compound: product)
        theoreticalYield = (limitingReactantAmount! / limitingReactantMolarMass!) * (Double(productCoefficient) / Double(limitingReactantCoefficient!)) * molarMassOfProduct
        
        return theoreticalYield!
    }
    
}
