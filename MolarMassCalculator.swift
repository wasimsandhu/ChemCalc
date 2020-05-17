//
//  MolarMassCalculator.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/10/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import Foundation
import UIKit

var elementSymbols = ["H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og"];

var atomicMasses = [1.0079, 4.0026, 6.941, 9.0122, 10.811, 12.0107, 14.0067, 15.9994, 18.9984, 20.1797, 22.9897, 24.305, 26.9815, 28.0855, 30.9738, 32.065, 35.453, 39.948, 39.0983, 40.078, 44.9559, 47.867, 50.9415, 51.9961, 54.938, 55.845, 58.9332, 58.6934, 63.546, 65.39, 69.723, 72.64, 74.9216, 78.96, 79.904, 83.8, 85.4678, 87.62, 88.9059, 91.224, 92.9064, 95.94, 98, 101.07, 102.9055, 106.42, 107.8682, 112.411, 114.818, 118.71, 121.76, 126.9045, 127.6, 131.293, 132.9055, 137.327, 138.9055, 140.116, 140.9077, 144.24, 144.913, 150.36, 151.964, 157.25, 158.9253, 162.5, 164.9303, 167.259, 168.9342, 173.04, 174.967, 178.49, 180.9479, 183.84, 186.207, 190.23, 192.217, 195.078, 196.9665, 200.59, 204.3833, 207.2, 208.9804, 208.982, 209.987, 222.018, 223.0197, 226.0254, 227.028, 232.038, 231.036, 238.029, 237.048, 244.0642, 243.0614, 247.070, 247.070, 251.0796, 254, 257.095, 258.1, 259.101, 262, 261, 262, 266, 264, 269, 268, 269, 272, 277, 286, 289, 288, 292, 292, 293]

let lowercase = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

let uppercase = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

let decimal = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

class MolarMassCalculator {
    
    var symbolMassDict: [String:Double] = [:]
    var index: Int!
    
    var element: String!
    var number: Int?
    var molarMass: Double?
    
    var elements = [String:Int]()
    var masses = [String:Double]()
    
    var dictElementsAsArray = [String]()
    var dictQuantitiesAsArray = [Int]()
    var dictMassesAsArray = [Double]()
    
    var compoundAdjusted: String!
    var compoundWithoutParentheses: String?
        
    func createDictionary() -> ([String:Double]) {
        // create dictionary with element symbols and respective masses
        for (a, b) in elementSymbols.enumerated() {
            symbolMassDict[b] = atomicMasses[a]
        }
        
        return symbolMassDict
    }
    
    func calculate(compound: String) -> (Double) {
        
        createDictionary()
        
        // clear previous calculation data
        dictMassesAsArray.removeAll()
        dictElementsAsArray.removeAll()
        dictQuantitiesAsArray.removeAll()
        elements.removeAll()
        masses.removeAll()
        
        if compound.contains("(") {
            compoundAdjusted = checkForPolyatomicIons(input: compound)
        } else {
            compoundAdjusted = compound
        }
        
        compoundAdjusted = compoundAdjusted.replacingOccurrences(of: "(g)", with: "")
        compoundAdjusted = compoundAdjusted.replacingOccurrences(of: "(s)", with: "")
        compoundAdjusted = compoundAdjusted.replacingOccurrences(of: "(aq)", with: "")
        compoundAdjusted = compoundAdjusted.replacingOccurrences(of: "(l)", with: "")
        
        // get individual characters of inputted string
        var characters: Array<String>! = compoundAdjusted.map { String($0) }
        
        // evaluate characters to seperate elements and quantities
        for character in characters {
            
            index = characters.index(of: character)
            
            if uppercase.contains(character) {
                // check if next character exists
                if characters.indices.contains(index + 1) {
                    
                    if lowercase.contains(characters[index + 1]) {
                        // if next character is lowercase, add character to first character and consider it an element
                        let element = character + characters[index + 1]
                        
                        // check if character after next character exists and is a decimal
                        if characters.indices.contains(index + 2) {
                            if decimal.contains(characters[index + 2]) {
                                
                                // check if decimal is single digit or double digit, then apply number to element
                                if characters.indices.contains(index + 3) {
                                    if decimal.contains(characters[index + 3]) {
                                        number = Int(characters[index + 2] + characters[index + 3])
                                        if elements[element] == nil {
                                            elements[element] = number
                                            characters[index] = ""
                                            characters[index + 1] = ""
                                            characters[index + 2] = ""
                                            characters[index + 3] = ""
                                        } else {
                                            elements[element] = elements[element]! + number!
                                            characters[index] = ""
                                            characters[index + 1] = ""
                                            characters[index + 2] = ""
                                            characters[index + 3] = ""
                                        }
                                    } else {
                                        number = Int(characters[index + 2])
                                        if elements[element] == nil {
                                            elements[element] = number
                                            characters[index] = ""
                                            characters[index + 1] = ""
                                            characters[index + 2] = ""
                                        } else {
                                            elements[element] = elements[element]! + number!
                                            characters[index] = ""
                                            characters[index + 1] = ""
                                            characters[index + 2] = ""
                                        }
                                    }
                                    
                                } else {
                                    // if decimal is not double digit, apply single digit number to element
                                    number = Int(characters[index + 2])
                                    if elements[element] == nil {
                                        elements[element] = number
                                        characters[index] = ""
                                        characters[index + 1] = ""
                                        characters[index + 2] = ""
                                    } else {
                                        elements[element] = elements[element]! + number!
                                        characters[index] = ""
                                        characters[index + 1] = ""
                                        characters[index + 2] = ""
                                    }
                                }
                            } else {
                                // if no decimal after lowercase letter, then element is one single element
                                if elements[element] == nil {
                                    elements[element] = 1
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                } else {
                                    elements[element] = elements[element]! + 1
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                }
                            }
                        } else {
                            // if no decimal after lowercase letter, then element is one single element
                            if elements[element] == nil {
                                elements[element] = 1
                                characters[index] = ""
                                characters[index + 1] = ""
                            } else {
                                elements[element] = elements[element]! + 1
                                characters[index] = ""
                                characters[index + 1] = ""
                            }
                        }
                        
                    } else if uppercase.contains(characters[index + 1]) {
                        // if next character is uppercase, consider first character an element and restart loop
                        let element = character
                        if elements[element] == nil {
                            elements[element] = 1
                            characters[index] = ""
                        } else {
                            elements[element] = elements[element]! + 1
                            characters[index] = ""
                        }
                        
                    } else if decimal.contains(characters[index + 1]) {
                        // if next character is a number, consider first character an element, assign number to it, then restart loop
                        let element = character
                        if (characters.indices.contains(index + 2)) {
                            
                            if (decimal.contains(characters[index + 2])) {
                                number = Int(characters[index + 1] + characters[index + 2])
                                if elements[element] == nil {
                                    elements[element] = number
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                } else {
                                    elements[element] = elements[element]! + number!
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                }
                            } else {
                                number = Int(characters[index + 1])
                                if elements[element] == nil {
                                    elements[element] = number
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                } else {
                                    elements[element] = elements[element]! + number!
                                    characters[index] = ""
                                    characters[index + 1] = ""
                                }
                            }
                            
                        } else {
                            number = Int(characters[index + 1])
                            if elements[element] == nil {
                                elements[element] = number
                                characters[index] = ""
                                characters[index + 1] = ""
                            } else {
                                elements[element] = elements[element]! + number!
                                characters[index] = ""
                                characters[index + 1] = ""
                            }
                        }
                    }
                } else {
                    // if next character doesn't exist, consider first character an element
                    let element = character
                    if elements[element] == nil {
                        elements[element] = 1
                    } else {
                        elements[element] = elements[element]! + 1
                    }
                }
            }
        }
        
        // get masses of elements, then add/multiply to get molar mass
        for (element, number) in elements {
            if let mass = symbolMassDict[element] {
                masses[element] = mass * Double(number)
            }
        }
        
        dictMassesAsArray = Array(masses.values)
        dictElementsAsArray = Array(elements.keys)
        dictQuantitiesAsArray = Array(elements.values)
        
        molarMass = dictMassesAsArray.reduce(0, +)
        
        return (molarMass!)
    }
    
    func getElementsAndQuantities() -> ([String:Int]) {
        return elements
    }
    
    func getElementsInCompound() -> (Array<String>) {
        return dictElementsAsArray
    }
    
    func getNumberOfElements() -> (Array<Int>) {
        return dictQuantitiesAsArray
    }
    
    // The laziest string manipulation algorithm of all time
    func checkForPolyatomicIons(input: String) -> String {
        
        compoundWithoutParentheses = input
        
        // CH2 group
        if input.contains("(CH2)2") {
            elements["C"] = 2
            elements["H"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)2", with: "")
        } else if input.contains("(CH2)3") {
            elements["C"] = 3
            elements["H"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)3", with: "")
        } else if input.contains("(CH2)4") {
            elements["C"] = 4
            elements["H"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)4", with: "")
        } else if input.contains("(CH2)5") {
            elements["C"] = 5
            elements["H"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)5", with: "")
        } else if input.contains("(CH2)6") {
            elements["C"] = 6
            elements["H"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)6", with: "")
        } else if input.contains("(CH2)7") {
            elements["C"] = 7
            elements["H"] = 14
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)7", with: "")
        } else if input.contains("(CH2)8") {
            elements["C"] = 8
            elements["H"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)8", with: "")
        } else if input.contains("(CH2)9") {
            elements["C"] = 9
            elements["H"] = 18
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)9", with: "")
        } else if input.contains("(CH2)10") {
            elements["C"] = 10
            elements["H"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CH2)10", with: "")
        }
        
        // Ammonium ion
        if input.contains("(NH4)2") {
            elements["N"] = 2
            elements["H"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NH4)2", with: "")
        } else if input.contains("(NH4)3") {
            elements["N"] = 3
            elements["H"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NH4)3", with: "")
        } else if input.contains("(NH4)4") {
            elements["N"] = 4
            elements["H"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NH4)4", with: "")
        } else if input.contains("(NH4)5") {
            elements["N"] = 5
            elements["H"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NH4)5", with: "")
        }
    
        // Nitrate ion
        if input.contains("(NO3)2") {
            elements["N"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO3)2", with: "")
        } else if input.contains("(NO3)3") {
            elements["N"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO3)3", with: "")
        } else if input.contains("(NO3)4)") {
            elements["N"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO3)4", with: "")
        } else if input.contains("(NO3)5") {
            elements["N"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO3)5", with: "")
        }
        
        // Nitrite ion
        if input.contains("(NO2)2") {
            elements["N"] = 2
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO2)2", with: "")
        } else if input.contains("(NO2)3") {
            elements["N"] = 3
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO2)3", with: "")
        } else if input.contains("(NO2)4)") {
            elements["N"] = 4
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO2)4", with: "")
        } else if input.contains("(NO2)5") {
            elements["N"] = 5
            elements["O"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(NO2)5", with: "")
        }
        
        // Sulfate ion
        if input.contains("(SO4)2") {
            elements["S"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO4)2", with: "")
        } else if input.contains("(SO4)3") {
            elements["S"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO4)3", with: "")
        } else if input.contains("(SO4)4") {
            elements["S"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO4)4", with: "")
        } else if input.contains("(SO4)5") {
            elements["S"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO4)5", with: "")
        }
        
        // Sulfite ion
        if input.contains("(SO3)2") {
            elements["S"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO3)2", with: "")
        } else if input.contains("(SO3)3") {
            elements["S"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO3)3", with: "")
        } else if input.contains("(SO3)4") {
            elements["S"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO3)4", with: "")
        } else if input.contains("(SO3)5") {
            elements["S"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SO3)5", with: "")
        }
        
        // Phosphate ion
        if input.contains("(PO4)2") {
            elements["P"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO4)2", with: "")
        } else if input.contains("(PO4)3") {
            elements["P"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO4)3", with: "")
        } else if input.contains("(PO4)4") {
            elements["P"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO4)4", with: "")
        } else if input.contains("(PO4)5") {
            elements["P"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO4)5", with: "")
        }
        
        // Phosphite ion
        if input.contains("(PO3)2") {
            elements["P"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO3)2", with: "")
        } else if input.contains("(PO3)3") {
            elements["P"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO3)3", with: "")
        } else if input.contains("(PO3)4") {
            elements["P"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO3)4", with: "")
        } else if input.contains("(PO3)5") {
            elements["P"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(PO3)5", with: "")
        }
        
        // Hydrogen phosphate ion
        if input.contains("(HPO4)2") {
            elements["H"] = 2
            elements["P"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HPO4)2", with: "")
        } else if input.contains("(HPO4)3") {
            elements["H"] = 3
            elements["P"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HPO4)3", with: "")
        } else if input.contains("(HPO4)4") {
            elements["H"] = 4
            elements["P"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HPO4)4", with: "")
        } else if input.contains("(HPO4)5") {
            elements["H"] = 5
            elements["P"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HPO4)5", with: "")
        }
        
        // Dihydrogen phosphate ion
        if input.contains("(H2PO4)2") {
            elements["H"] = 4
            elements["P"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H2PO4)2", with: "")
        } else if input.contains("(H2PO4)3") {
            elements["H"] = 6
            elements["P"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H2PO4)3", with: "")
        } else if input.contains("(H2PO4)4") {
            elements["H"] = 8
            elements["P"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H2PO4)4", with: "")
        } else if input.contains("(H2PO4)5") {
            elements["H"] = 10
            elements["P"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H2PO4)5", with: "")
        }
        
        // Hydrogen sulfate ion
        if input.contains("(HSO4)2") {
            elements["H"] = 2
            elements["S"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HSO4)2", with: "")
        } else if input.contains("(HSO4)3") {
            elements["H"] = 3
            elements["S"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HSO4)3", with: "")
        } else if input.contains("(HSO4)4") {
            elements["H"] = 4
            elements["S"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HSO4)4", with: "")
        } else if input.contains("(HSO4)5") {
            elements["H"] = 5
            elements["S"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HSO4)5", with: "")
        }
        
        // Hydroxide ion
        if input.contains("(OH)2") {
            elements["H"] = 2
            elements["O"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(OH)2", with: "")
        } else if input.contains("(OH)3") {
            elements["H"] = 3
            elements["O"] = 3
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(OH)3", with: "")
        } else if input.contains("(OH)4") {
            elements["H"] = 4
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(OH)4", with: "")
        } else if input.contains("(OH)5") {
            elements["H"] = 5
            elements["O"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(OH)5", with: "")
        }
        
        // Peroxide ion
        if input.contains("(O2)2") {
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(O2)2", with: "")
        } else if input.contains("(O2)3") {
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(O2)3", with: "")
        } else if input.contains("(O2)4") {
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(O2)4", with: "")
        } else if input.contains("(O2)5") {
            elements["O"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(O2)5", with: "")
        }
        
        // Acetate ion
        if input.contains("(C2H3O2)2") {
            elements["C"] = 4
            elements["H"] = 6
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2H3O2)2", with: "")
        } else if input.contains("(C2H3O2)3") {
            elements["C"] = 6
            elements["H"] = 9
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2H3O2)3", with: "")
        } else if input.contains("(C2H3O2)4") {
            elements["C"] = 8
            elements["H"] = 12
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2H3O2)4", with: "")
        } else if input.contains("(C2H3O2)5") {
            elements["C"] = 10
            elements["H"] = 15
            elements["O"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2H3O2)5", with: "")
        }
        
        // Perchlorate ion
        if input.contains("(ClO4)2") {
            elements["Cl"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO4)2", with: "")
        } else if input.contains("(ClO4)3") {
            elements["Cl"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO4)3", with: "")
        } else if input.contains("(ClO4)4") {
            elements["Cl"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO4)4", with: "")
        } else if input.contains("(ClO4)5") {
            elements["Cl"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO4)5", with: "")
        }
        
        // Chlorate ion
        if input.contains("(ClO3)2") {
            elements["Cl"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO3)2", with: "")
        } else if input.contains("(ClO3)3") {
            elements["Cl"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO3)3", with: "")
        } else if input.contains("(ClO3)4") {
            elements["Cl"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO3)4", with: "")
        } else if input.contains("(ClO3)5") {
            elements["Cl"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO3)5", with: "")
        }
        
        // Chlorite ion
        if input.contains("(ClO2)2") {
            elements["Cl"] = 2
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO2)2", with: "")
        } else if input.contains("(ClO2)3") {
            elements["Cl"] = 3
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO2)3", with: "")
        } else if input.contains("(ClO2)4") {
            elements["Cl"] = 4
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO2)4", with: "")
        } else if input.contains("(ClO2)5") {
            elements["Cl"] = 5
            elements["O"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO2)5", with: "")
        }
        
        // Hypochlorite ion
        if input.contains("(ClO)2") {
            elements["Cl"] = 2
            elements["O"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO)2", with: "")
        } else if input.contains("(ClO)3") {
            elements["Cl"] = 3
            elements["O"] = 3
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO)3", with: "")
        } else if input.contains("(ClO)4") {
            elements["Cl"] = 4
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO)4", with: "")
        } else if input.contains("(ClO)5") {
            elements["Cl"] = 5
            elements["O"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(ClO)5", with: "")
        }
        
        // Chromate ion
        if input.contains("(CrO4)2") {
            elements["Cr"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CrO4)2", with: "")
        } else if input.contains("(CrO4)3") {
            elements["Cr"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CrO4)3", with: "")
        } else if input.contains("(CrO4)4") {
            elements["Cr"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CrO4)4", with: "")
        } else if input.contains("(CrO4)5") {
            elements["Cr"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CrO4)5", with: "")
        }
        
        // Dichromate ion
        if input.contains("(Cr2O7)2") {
            elements["Cr"] = 4
            elements["O"] = 14
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Cr2O7)2", with: "")
        } else if input.contains("(Cr2O7)3") {
            elements["Cr"] = 6
            elements["O"] = 21
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Cr2O7)3", with: "")
        } else if input.contains("(Cr2O7)4") {
            elements["Cr"] = 8
            elements["O"] = 28
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Cr2O7)4", with: "")
        } else if input.contains("(Cr2O7)5") {
            elements["Cr"] = 10
            elements["O"] = 35
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Cr2O7)5", with: "")
        }
        
        // Permanganate ion
        if input.contains("(MnO4)2") {
            elements["Mn"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(MnO4)2", with: "")
        } else if input.contains("(MnO4)3") {
            elements["Mn"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(MnO4)3", with: "")
        } else if input.contains("(MnO4)4") {
            elements["Mn"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(MnO4)4", with: "")
        } else if input.contains("(MnO4)5") {
            elements["Mn"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(MnO4)5", with: "")
        }
        
        // Cyanide ion
        if input.contains("(CN)2") {
            elements["C"] = 2
            elements["N"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CN)2", with: "")
        } else if input.contains("(CN)3") {
            elements["C"] = 2
            elements["N"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CN)3", with: "")
        } else if input.contains("(CN)4") {
            elements["C"] = 2
            elements["N"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CN)4", with: "")
        } else if input.contains("(CN)5") {
            elements["C"] = 5
            elements["N"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CN)5", with: "")
        }
        
        // Cyanate ion
        if input.contains("(CNO)2") {
            elements["C"] = 2
            elements["N"] = 2
            elements["O"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CNO)2", with: "")
        } else if input.contains("(CNO)3") {
            elements["C"] = 3
            elements["N"] = 3
            elements["O"] = 3
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CNO)3", with: "")
        } else if input.contains("(CNO)4") {
            elements["C"] = 4
            elements["N"] = 4
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CNO)4", with: "")
        } else if input.contains("(CNO)5") {
            elements["C"] = 5
            elements["N"] = 5
            elements["O"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CNO)5", with: "")
        }
        
        // Thiocyanate ion
        if input.contains("(SCN)2") {
            elements["S"] = 2
            elements["C"] = 2
            elements["N"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SCN)2", with: "")
        } else if input.contains("(SCN)3") {
            elements["S"] = 3
            elements["C"] = 3
            elements["N"] = 3
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SCN)3", with: "")
        } else if input.contains("(SCN)4") {
            elements["S"] = 4
            elements["C"] = 4
            elements["N"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SCN)4", with: "")
        } else if input.contains("(SCN)5") {
            elements["S"] = 5
            elements["C"] = 5
            elements["N"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(SCN)5", with: "")
        }
        
        // Carbonate ion
        if input.contains("(CO3)2") {
            elements["C"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CO3)2", with: "")
        } else if input.contains("(CO3)3") {
            elements["C"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CO3)3", with: "")
        } else if input.contains("(CO3)4") {
            elements["C"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CO3)4", with: "")
        } else if input.contains("(CO3)5") {
            elements["C"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(CO3)5", with: "")
        }
        
        // Hydrogen carbonate ion
        if input.contains("(HCO3)2") {
            elements["H"] = 2
            elements["C"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HCO3)2", with: "")
        } else if input.contains("(HCO3)3") {
            elements["H"] = 3
            elements["C"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HCO3)3", with: "")
        } else if input.contains("(HCO3)4") {
            elements["H"] = 4
            elements["C"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HCO3)4", with: "")
        } else if input.contains("(HCO3)5") {
            elements["H"] = 5
            elements["C"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(HCO3)5", with: "")
        }
        
        // Oxalate ion
        if input.contains("(C2O4)2") {
            elements["C"] = 4
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2O4)2", with: "")
        } else if input.contains("(C2O4)3") {
            elements["C"] = 6
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2O4)3", with: "")
        } else if input.contains("(C2O4)4") {
            elements["C"] = 8
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2O4)4", with: "")
        } else if input.contains("(C2O4)5") {
            elements["C"] = 10
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(C2O4)5", with: "")
        }
        
        // Thiosulfate ion
        if input.contains("(S2O3)2") {
            elements["S"] = 4
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(S2O3)2", with: "")
        } else if input.contains("(S2O3)3") {
            elements["S"] = 6
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(S2O3)3", with: "")
        } else if input.contains("(S2O3)4") {
            elements["S"] = 8
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(S2O3)4", with: "")
        } else if input.contains("(S2O3)5") {
            elements["S"] = 10
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(S2O3)5", with: "")
        }
        
        // Mercury ion
        if input.contains("(Hg2)2") {
            elements["Hg"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Hg2)2", with: "")
        } else if input.contains("(Hg2)3") {
            elements["Hg"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Hg2)3", with: "")
        } else if input.contains("(Hg2)4") {
            elements["Hg"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Hg2)4", with: "")
        } else if input.contains("(Hg2)5") {
            elements["Hg"] = 10
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(Hg2)5", with: "")
        }
        
        // Hydronium ion
        if input.contains("(H3O)2") {
            elements["H"] = 6
            elements["O"] = 2
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H3O)2", with: "")
        } else if input.contains("(H3O)3") {
            elements["H"] = 9
            elements["O"] = 3
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H3O)3", with: "")
        } else if input.contains("(H3O)4") {
            elements["H"] = 12
            elements["O"] = 4
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H3O)4", with: "")
        } else if input.contains("(H3O)5") {
            elements["H"] = 15
            elements["O"] = 5
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(H3O)5", with: "")
        }
        
        // Iodate ion
        if input.contains("(IO3)2") {
            elements["I"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO3)2", with: "")
        } else if input.contains("(IO3)3") {
            elements["I"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO3)3", with: "")
        } else if input.contains("(IO3)4") {
            elements["I"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO3)4", with: "")
        } else if input.contains("(IO3)5") {
            elements["I"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO3)5", with: "")
        }
        
        // Periodate ion
        if input.contains("(IO4)2") {
            elements["I"] = 2
            elements["O"] = 8
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO4)2", with: "")
        } else if input.contains("(IO4)3") {
            elements["I"] = 3
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO4)3", with: "")
        } else if input.contains("(IO4)4") {
            elements["I"] = 4
            elements["O"] = 16
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO4)4", with: "")
        } else if input.contains("(IO4)5") {
            elements["I"] = 5
            elements["O"] = 20
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(IO4)5", with: "")
        }
        
        // Bromate ion
        if input.contains("(BrO3)2") {
            elements["Br"] = 2
            elements["O"] = 6
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(BrO3)2", with: "")
        } else if input.contains("(BrO3)3") {
            elements["Br"] = 3
            elements["O"] = 9
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(BrO3)3", with: "")
        } else if input.contains("(BrO3)4") {
            elements["Br"] = 4
            elements["O"] = 12
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(BrO3)4", with: "")
        } else if input.contains("(BrO3)5") {
            elements["Br"] = 5
            elements["O"] = 15
            compoundWithoutParentheses = compoundWithoutParentheses?.replacingOccurrences(of: "(BrO3)5", with: "")
        }
        
        return compoundWithoutParentheses!
    }
    
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
