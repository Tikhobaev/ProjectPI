//
//  UIViewController+Alerts.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 28.11.2019.
//  Copyright © 2019 Dmitry Lemaykin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(title: String = "Ошибка", message: String, okHandler: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okHandler))

        present(alert, animated: true)
    }
    
    func showMessageAlert(title: String = "Сообщение", message: String, okHandler: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okHandler))

        present(alert, animated: true)
    }
    
    func showConformationAlert(title: String = "Сообщение", message: String, actionHandler: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: actionHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: actionHandler))

        present(alert, animated: true)
    }
}
