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
        " • “Beaker” app icon by Blake Thompson from the Noun Project: https://thenounproject.com/term/beaker/9563/ \n" +
            " • Computing reduced row echelon form of a matrix: https://rosettacode.org/wiki/Reduced_row_echelon_form#Swift \n" +
            " • Find LCM of Doubles in Swift by Martin: https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift \n" +
            " • Subscripting and superscripting text by Nicolò Candiani: https://github.com/nicolocandiani/subandsuperscripttext \n" + " • Icons by Icons8: https://icons8.com/icon/new-icons/all \n"
        
        let string2 = "\nChemistry Data\n" +
            " • Periodic elements data by Chris Andrejewski: https://github.com/andrejewski/periodic-table \n" +
            " • Element electron configurations: http://periodictable.com/Properties/A/ElectronConfigurationString.an.html \n" +
            " • Number of neutrons in elements: http://www.elementalmatter.info/number-of-neutrons.htm \n" +
        " • Standard thermodyanmic quantities, acid/base dissociation constants, solubility product constants, and standard electrode potentials from Chemistry: A Molecular Approach by Nivaldo J. Tro \n" +
        " • Chemical compounds and formulas database compiled by Devun Birk \n\n"
    
        let string = (string1 + string2 + "Built and designed by Wasim Sandhu \n") as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0)]
        
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Chemistry Data"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Libraries & Code"))
        
        return attributedString
    }
}
