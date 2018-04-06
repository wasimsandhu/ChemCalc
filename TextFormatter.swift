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
    
    var configToFormat: String?
    var formattedConfig: NSMutableAttributedString!
    
    var newLetters: String?
    var formattedLetters: NSMutableAttributedString!
    
    func ka(letters: String) -> (NSMutableAttributedString) {
        newLetters = letters.replacingOccurrences(of: "Kb", with: "K@b$")
        newLetters = newLetters?.replacingOccurrences(of: "Ka1", with: "K@a1$")
        newLetters = newLetters?.replacingOccurrences(of: "Ka2", with: "K@a2$")
        newLetters = newLetters?.replacingOccurrences(of: "Ka3", with: "K@a3$")
        formattedLetters = newLetters?.customText()
        return formattedLetters
    }
    
    // fixes subscript/superscript in chemical formulas
    func fix(formula: String) -> (NSMutableAttributedString) {
        
        // subscripting states of matter
        formulaToFormat = formula.replacingOccurrences(of: "(g)", with: "@(g)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(l)", with: "@(l)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s)", with: "@(s)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(aq)", with: "@(aq)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, graphite)", with: "@(s, graphite)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, diamond)", with: "@(s, diamond)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, white)", with: "@(s, white)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, red)", with: "@(s, red)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, monoclinic)", with: "@(s, monoclinic)$")
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "(s, rhombic)", with: "@(s, rhombic)$")
        
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
        formulaToFormat = formulaToFormat?.replacingOccurrences(of: "0", with: "@0$")
        
        // superscripting charges on molecules
        if formulaToFormat!.contains("@3$+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@3$+", with: "{3+}")
        } else if formulaToFormat!.contains("@2$+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@2$+", with: "{2+}")
        } else if formulaToFormat!.contains("+") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "+", with: "{+}")
        }
        
        if formulaToFormat!.contains("NO@3$-") || formulaToFormat!.contains("HCO@3$-") || formulaToFormat!.contains("ClO@3$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@3$-", with: "@3${-}")
        } else if formulaToFormat!.contains("NO@2$-") || formulaToFormat!.contains("C@2$H@3$O@2$-") || formulaToFormat!.contains("ClO@2$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@2$-", with: "@2${-}")
        } else if formulaToFormat!.contains("@3$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@3$-", with: "{3-}")
        } else if formulaToFormat!.contains("@2$-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "@2$-", with: "{2-}")
        } else if formulaToFormat!.contains("-") {
            formulaToFormat = formulaToFormat?.replacingOccurrences(of: "-", with: "{-}")
        }
        
        formattedFormula = formulaToFormat?.customText()
        return formattedFormula!
    }
    
    func fixElectron(config: String, font: String) -> (NSMutableAttributedString) {
        
        // s
        configToFormat = config.replacingOccurrences(of: "s1", with: "s{1}")
        configToFormat = configToFormat?.replacingOccurrences(of: "s2", with: "s{2}")
        
        // p
        configToFormat = configToFormat?.replacingOccurrences(of: "p1", with: "p{1}")
        configToFormat = configToFormat?.replacingOccurrences(of: "p2", with: "p{2}")
        configToFormat = configToFormat?.replacingOccurrences(of: "p3", with: "p{3}")
        configToFormat = configToFormat?.replacingOccurrences(of: "p4", with: "p{4}")
        configToFormat = configToFormat?.replacingOccurrences(of: "p5", with: "p{5}")
        configToFormat = configToFormat?.replacingOccurrences(of: "p6", with: "p{6}")
        
        // d
        configToFormat = configToFormat?.replacingOccurrences(of: "d10", with: "d{10}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d1", with: "d{1}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d2", with: "d{2}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d3", with: "d{3}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d4", with: "d{4}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d5", with: "d{5}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d6", with: "d{6}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d7", with: "d{7}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d8", with: "d{8}")
        configToFormat = configToFormat?.replacingOccurrences(of: "d9", with: "d{9}")
        
        // f
        configToFormat = configToFormat?.replacingOccurrences(of: "f10", with: "f{10}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f11", with: "f{11}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f12", with: "f{12}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f13", with: "f{13}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f14", with: "f{14}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f1", with: "f{1}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f2", with: "f{2}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f3", with: "f{3}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f4", with: "f{4}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f5", with: "f{5}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f6", with: "f{6}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f7", with: "f{7}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f8", with: "f{8}")
        configToFormat = configToFormat?.replacingOccurrences(of: "f9", with: "f{9}")
        
        if font == "BIG" {
            formattedConfig = configToFormat?.customText2(font: 18, superFont: 14)
        } else if font == "SMALL" {
            formattedConfig = configToFormat?.customText2(font: 15, superFont: 12)
        }
        
        return formattedConfig
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

extension String {
    func customText2(font: CGFloat, superFont: CGFloat) -> NSMutableAttributedString {
        
        let fontSuper: UIFont? = UIFont(name: "Helvetica", size: superFont)
        let font = UIFont(name: "Helvetica", size: font)
        
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
                    attString.setAttributes([NSAttributedStringKey.font:fontSuper!,NSAttributedStringKey.baselineOffset:5], range: NSRange(location:b,length:1))
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

// https://gist.github.com/budidino/8585eecd55fd4284afaaef762450f98e
extension String {
    func trunc(length: Int, trailing: String = "...") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}
