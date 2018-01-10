//
//  TextFormatter.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 1/8/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import Foundation
import UIKit

class TextFormatter {
    
    var formulaToFormat: String?
    var formattedFormula: NSMutableAttributedString!
    
    // fixes subscript/superscript in chemical formulas
    func fix(formula: String) -> (NSMutableAttributedString) {
        
        // subscripting states of matter
        formulaToFormat = formula.replacingOccurrences(of: "(g)", with: "@(g)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(l)", with: "@(l)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s)", with: "@(s)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(aq)", with: "@(aq)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, graphite)", with: "@(s, graphite)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, diamond)", with: "@(s, diamond)$")
        
        // subscripting number of atoms
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "1", with: "@1$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "2", with: "@2$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "3", with: "@3$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "4", with: "@4$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "5", with: "@5$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "6", with: "@6$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "7", with: "@7$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "8", with: "@8$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "9", with: "@9$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "10", with: "@10$")
        
        // superscripting charges on molecules
        if formulaToFormat!.contains("@3$+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@3$+", with: "{3+}")
        } else if formulaToFormat!.contains("@2$+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@2$+", with: "{2+}")
        } else if formulaToFormat!.contains("+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "+", with: "{+}")
        }
        
        if formulaToFormat!.contains("@3$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@3$-", with: "{3-}")
        } else if formulaToFormat!.contains("@2$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@2$-", with: "{2-}")
        } else if formulaToFormat!.contains("-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "-", with: "{-}")
        }
        
        formattedFormula = formulaToFormat?.customText()
        return formattedFormula!
    }
    
}

/* HELPFUL STRING EXTENSIONS */
// https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

// https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}

// https://github.com/nicolocandiani/subandsuperscripttext
extension String {
    
    func customText() -> NSMutableAttributedString {
        
        let fontSuper: UIFont? = UIFont(name: "Helvetica", size: 14)
        let font = UIFont(name: "Helvetica", size: 18)
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font:font!])
        
        var indexA = Array(repeating: 0, count: 10)
        var indexB = Array(repeating: 0, count: 10)
        var indexC = Array(repeating: 0, count: 10)
        var indexD = Array(repeating: 0, count: 10)
        
        var x = 0
        var z = 0
        var y = 0
        var w = 0
        
        for a in 0..<self.count{
            let index = self.index(self.startIndex, offsetBy: a)
            if self[index] == "{" {
                indexA[x] = a
                debugPrint(indexA[x])
                x+=1
            }
            if self[index] == "}" {
                indexB[z] = a
                debugPrint(indexB[z])
                z+=1
            }
            if self[index] == "@" {
                indexC[y] = a
                y+=1
            }
            if self[index] == "$" {
                indexD[w] = a
                w+=1
            }
        }
        
        
        
        for  a in 0..<10 {
            
            // superscript
            if indexA[a] != 0 || indexB[a] != 0 {
                for b in indexA[a]+1..<indexB[a] {
                    attString.setAttributes([NSAttributedStringKey.font:fontSuper!,NSAttributedStringKey.baselineOffset:10], range: NSRange(location:b,length:1))
                }
            }
            
            // subscript
            if indexC[a] != 0 || indexD[a] != 0 {
                for b in indexC[a]+1..<indexD[a] {
                    attString.setAttributes([NSAttributedStringKey.font:fontSuper!,NSAttributedStringKey.baselineOffset:-5], range: NSRange(location:b,length:1))
                }
            }
        }
        
        attString.mutableString.replaceOccurrences(of: "{", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "}", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "@", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        attString.mutableString.replaceOccurrences(of: "$", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: attString.length))
        
        return attString
    }
}