//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 30.03.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//
//  A base class for all ViewControllers is the app

import UIKit

class BaseViewController: UIViewController {
    
    public var segueHandler: ((UIStoryboardSegue, Any?) -> Void)?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueHandler?(segue, sender)
    }
    
    // Mark - Common Init methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public func initialize() {
        // A good place for common initialization
    }
    
    // Hide keyboard
    // https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
        
    public func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            showErrorAlert(message: "The app could not open URL: \(url)")
            return
        }
            
        UIApplication.shared.open(url)
    }
}

// MARK: - Phone Call
extension BaseViewController {
    
    func call(_ phoneNumber: String) {
        let phoneNumber = phoneNumber.filter("0123456789.".contains)
        guard let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            showAlertCallsNotAvailable()
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func showAlertCallsNotAvailable() {
        let noPhoneAppsAlertController = UIAlertController(title: "Can't make calls", message: "Your device does not support telephone calls", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        noPhoneAppsAlertController.addAction(okAction)
            
        present(noPhoneAppsAlertController, animated: true)
    }
}
