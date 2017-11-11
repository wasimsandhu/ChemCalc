//
//  MolarMassCalculator.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 11/10/17.
//  Copyright © 2017 Wasim Sandhu. All rights reserved.
//

import Foundation

var elementSymbols = ["H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Uub", "Nh", "Uuq", "Mc", "Uuh", "Ts", "Og"];

var atomicMasses = [1.0079, 4.0026, 6.941, 9.0122, 10.811, 12.0107, 14.0067, 15.9994, 18.9984, 20.1797, 22.9897, 24.305, 26.9815, 28.0855, 30.9738, 32.065, 35.453, 39.948, 39.0983, 40.078, 44.9559, 47.867, 50.9415, 51.9961, 54.938, 55.845, 58.9332, 58.6934, 63.546, 65.39, 69.723, 72.64, 74.9216, 78.96, 79.904, 83.8, 85.4678, 87.62, 88.9059, 91.224, 92.9064, 95.94, 98, 101.07, 102.9055, 106.42, 107.8682, 112.411, 114.818, 118.71, 121.76, 126.9045, 127.6, 131.293, 132.9055, 137.327, 138.9055, 140.116, 140.9077, 144.24, 144.913, 150.36, 151.964, 157.25, 158.9253, 162.5, 164.9303, 167.259, 168.9342, 173.04, 174.967, 178.49, 180.9479, 183.84, 186.207, 190.23, 192.217, 195.078, 196.9665, 200.59, 204.3833, 207.2, 208.9804, 208.982, 209.987, 222.018, 223.0197, 226.0254, 227.028, 232.038, 231.036, 238.029, 237.048, 244.0642, 243.0614, 247.070, 247.070, 251.0796, 254, 257.095, 258.1, 259.101, 262, 261, 262, 266, 264, 269, 268, 269, 272, 277, 0, 289, 0, 298, 0, 0]

class MolarMassCalculator {
    
    var symbolMassDict: [String:Double] = [:]
    var index: Int!
    
    let lowercase = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    let uppercase = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    let decimal = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    var element: String!
    var molarMass: Double?
    
    var elements = [String:Int]()
    var masses = [String:Double]()
    
    var dictElementsAsArray = [String]()
    var dictQuantitiesAsArray = [Int]()
    var dictMassesAsArray = [Double]()
        
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
        
        // get individual characters of inputted string
        let characters = compound.characters.map { String($0) }
        
        // evaluate characters to seperate elements and quantities
        for character in characters {
            if (uppercase.contains(character)) {
                
                index = characters.index(of: character)
                
                // check if next character exists
                if (characters.indices.contains(index + 1)) {
                    
                    if (lowercase.contains(characters[index + 1])) {
                        // if next character is lowercase, add character to first character and consider it an element
                        let element = character + characters[index + 1]
                        
                        // check how many atoms there are
                        if (characters.indices.contains(index + 2)) {
                            if (decimal.contains(characters[index + 2])) {
                                if (characters.indices.contains(index + 3)) {
                                    if (decimal.contains(characters[index + 3])) {
                                        let number = Int(characters[index + 2] + characters[index + 3])
                                        elements[element] = number
                                    } else {
                                        let number = Int(characters[index + 2])
                                        elements[element] = number
                                    }
                                } else {
                                    let number = Int(characters[index + 2])
                                    elements[element] = number
                                }
                            } else {
                                let number = 1
                                elements[element] = number
                            }
                        } else {
                            let number = 1
                            elements[element] = number
                        }
                        
                    } else if (uppercase.contains(characters[index + 1])) {
                        // if next character is uppercase, consider first character an element and restart loop
                        let element = character
                        let number = 1
                        elements[element] = number
                        
                    } else if (decimal.contains(characters[index + 1])) {
                        // if next character is a number, consider first character an element, assign number to it, then restart loop
                        let element = character
                        if (characters.indices.contains(index + 2)) {
                            if (decimal.contains(characters[index + 2])) {
                                let number = Int(characters[index + 1] + characters[index + 2])
                                elements[element] = number
                            } else {
                                let number = Int(characters[index + 1])
                                elements[element] = number
                            }
                        } else {
                            let number = Int(characters[index + 1])
                            elements[element] = number
                        }
                    }
                } else {
                    // if next character doesn't exist, consider first character an element
                    let element = character
                    let number = 1
                    elements[element] = number
                }
            }
        }
        
        // get masses of elements, then add/multiply to get molar mass
        for (element, number) in elements {
            let mass = symbolMassDict[element]
            masses[element] = mass! * Double(number)
        }
        
        dictMassesAsArray = Array(masses.values)
        dictElementsAsArray = Array(elements.keys)
        dictQuantitiesAsArray = Array(elements.values)
        
        molarMass = dictMassesAsArray.reduce(0, +)
        
        return (molarMass!)
    }
    
    func getElementsInCompound() -> (Array<String>) {
        return dictElementsAsArray
    }
    
    func getNumberOfElements() -> (Array<Int>) {
        return dictQuantitiesAsArray
    }
    
}
