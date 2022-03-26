//
//  UITextView+Attributes.swift
//  BonnetDriver
//
//  Created by Dmitry Lemaykin on 20.04.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//
//  Big discussion:
//  https://stackoverflow.com/questions/27652227/how-can-i-add-placeholder-text-inside-of-a-uitextview-in-swift

import UIKit

@IBDesignable
class TextViewWithPlaceholder: UITextView {

    // Ensures that the placeholder text is never returned as the field's text
    override var text: String! {
        get {
            // When showing the placeholder, there's no real text to return
            showingPlaceholder ? "" : super.text
        }
        set {
            super.text = newValue
        }
    }
    
    @IBInspectable
    var placeholderText: String = ""
    
    // Standard iOS placeholder color (#C7C7CD). See https://stackoverflow.com/questions/31057746/whats-the-default-color-for-placeholder-text-in-uitextfield
    @IBInspectable
    var placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    
    // Keeps track of whether the field is currently showing a placeholder
    private var showingPlaceholder: Bool = true

    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        if text.isEmpty {
            showPlaceholderText()
        }
    }

    override func becomeFirstResponder() -> Bool {
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            textColor = nil // Put the text back to the default, unmodified color
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }

    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        text = placeholderText
    }
}

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame:
            CGRect(
                x: 0.0,
                y: 0.0,
                width: UIScreen.main.bounds.size.width,
                height: 44.0
            )
        )
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
