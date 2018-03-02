//
//  CreditsVC.swift
//  ChemCalc
//
//  Created by Wasim Sandhu on 2/28/18.
//  Copyright © 2018 Wasim Sandhu. All rights reserved.
//

import UIKit

class CreditsVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        textView.delegate = self
        textView.scrollRangeToVisible(NSMakeRange(0,0))
        textView.attributedText = formattedText()
    }
    
    func formattedText() -> NSAttributedString {
        
        let string1 = "\nLibraries & Code\n" +
            " • Computing reduced row echelon form of a matrix: https://rosettacode.org/wiki/Reduced_row_echelon_form#Swift \n" +
            " • Find LCM of Doubles in Swift by Martin R: https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift \n" +
            " • Subscripting and superscripting text by Nicolò Candiani: https://github.com/nicolocandiani/subandsuperscripttext \n"
            + " • String truncate extension: https://gist.github.com/budidino/8585eecd55fd4284afaaef762450f98e \n"
        
        let string2 = "\nChemistry Data\n" +
            " • Periodic elements data by Chris Andrejewski: https://github.com/andrejewski/periodic-table \n" +
            " • Element electron configurations: http://periodictable.com/Properties/A/ElectronConfigurationString.an.html \n" +
            " • Number of neutrons in elements: http://www.elementalmatter.info/number-of-neutrons.htm \n" +
        " • Standard thermodyanmic quantities at 25°C from Chemistry: A Molecular Approach by Nivaldo J. Tro \n" +
        " • Chemical compounds and formulas database compiled by Devun Birk \n\n"
    
        let string = (string1 + string2) as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 18.0)])
        
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24.0)]
        let italicFontAttribute = [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 18.0)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Chemistry Data"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Libraries & Code"))
        
        // Links to be italicized
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "https://github.com/andrejewski/periodic-table"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "http://www.elementalmatter.info/number-of-neutrons.htm"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "http://periodictable.com/Properties/A/ElectronConfigurationString.an.html"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "https://rosettacode.org/wiki/Reduced_row_echelon_form#Swift"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "https://github.com/nicolocandiani/subandsuperscripttext"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "https://gist.github.com/budidino/8585eecd55fd4284afaaef762450f98e"))
        attributedString.addAttributes(italicFontAttribute, range: string.range(of: "Chemistry: A Molecular Approach"))
        
        
        return attributedString
    }
}
