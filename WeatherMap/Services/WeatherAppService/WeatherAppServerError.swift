//
//  WeatherAppServerError.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

enum WeatherAppServerError: Error {
    case parsing(_ message: String)
    case network(_ error: Error)
    case server(_ message: String)
    
    var message: String {
        switch self {
            case .server(let message):
                return message
            case .parsing(let message):
                return message
            case .network(let error):
                return error.localizedDescription
        }
    }
}
