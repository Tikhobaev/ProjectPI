//
//  UILabel+Spacing.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 30.04.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//
//  Inspiered by:
//  https://stackoverflow.com/questions/37689785/how-do-i-change-the-letter-spacing-in-a-uilabel/37690136

import UIKit

@IBDesignable
open class SpacingLabel : UILabel {
    
    @IBInspectable
    open var characterSpacing: CGFloat = 1 {
        didSet {
            guard let text = text else {
                return
            }
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }

    }
}
