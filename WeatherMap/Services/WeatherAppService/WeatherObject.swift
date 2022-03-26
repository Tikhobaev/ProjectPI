//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

struct WeatherObject<T: Codable>: Codable {
    let data: T
    
    static func parse(_ data: Data) -> Result<T?, WeatherAppServerError> {
        do {
            let decodedValue = try JSONDecoder().decode(Self.self, from: data)
            return .success(decodedValue.data)
        } catch let error {
            if let weatherError = try? JSONDecoder().decode(WeatherObject<WeatherError>.self, from: data) {
                return .failure(.server(weatherError.data.error.first?.msg ?? "No error message"))
            }
            return .failure(.parsing("Parsing error: \(error.localizedDescription)"))
        }
    }
}

struct WeatherError: Codable {
    let error: [ErrorObject]
}

struct ErrorObject: Codable {
    let msg: String
}
