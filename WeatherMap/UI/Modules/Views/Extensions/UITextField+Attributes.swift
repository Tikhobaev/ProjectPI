//
//  UITextField+Attributes.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 30.03.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable
    var maxTextLength: Int = 0
    
    // Needed for storybords only
    @IBInspectable
    var allowedCharactersSting: String? {
        get {
            if let characterSet = allowedCharacterSet {
                return String(characterSet.description)
            }
            return nil
        }
        set {
            if let charactersSting = newValue {
                allowedCharacterSet = CharacterSet(charactersIn: charactersSting)
            } else {
                allowedCharacterSet = nil
            }
        }
    }
    // Not visible in interface builder
    var allowedCharacterSet: CharacterSet? = nil
    
    var didBecomeFirstResponder: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.delegate = self
    }
    
    override func becomeFirstResponder() -> Bool {
        let isFirstResponder = super.becomeFirstResponder()
        
        if isFirstResponder {
            didBecomeFirstResponder?()
        }
        
        return isFirstResponder
    }
}

extension UITextField {
    
    @IBInspectable
    var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
}

extension DesignableTextField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        
        if maxTextLength != 0 {
            if range.location + range.length >= maxTextLength {
                if text?.count != 0 {
                    return false
                }
            }
        }
        
        if let allowedCharacterSet = allowedCharacterSet {
            return string.rangeOfCharacter(from: allowedCharacterSet) != nil
        }
         
        return true
    }
    
}
