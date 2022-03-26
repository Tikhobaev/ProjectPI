//
//  UIImage+WeatherImages.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 14.10.2020.
//

import UIKit

extension UIImage {
    
    convenience init?(weatherDesctiption: String?) {
        guard let weatherDesctiption = weatherDesctiption else {
            return nil
        }
        let systemName = Self.weatherImagesForDescription[weatherDesctiption] ?? "cloud.sun"
        self.init(systemName: systemName)
    }
    
    convenience init?(weatherCodeString: String) {
        guard let code = Int(weatherCodeString) else {
            return nil
        }
        let systemName = Self.weatherImagesForCode[code] ?? "cloud.sun"
        self.init(systemName: systemName)
    }
    
    private static let weatherImagesForDescription = [
        "Солнечно":                     "sun.max",
        "Ясно":                         "sun.min",
        "Переменная облачность":        "cloud.sun",
        "Облачно":                      "cloud",
        "Пасмурно":                     "cloud.drizzle",
        "Дымка":                        "cloud.fog",
        "Местами дождь":                "cloud.rain",
        "Местами снег":                 "cloud.snow",
        "Местами дождь со снегом":      "cloud.snow.fill",
        "Местами замерзающая морось":   "thermometer.snowflake",
        "Местами грозы":                "cloud.sun.bolt.fill",
        "Поземок":                      "cloud.bolt.rain",
        "Метель":                       "cloud.bolt.rain",
        "Туман":                        "cloud.fog",
        "Переохлажденный туман":        "cloud.fog",
        "Местами слабая морось":        "cloud.rain",
        "Слабая морось":                "cloud.rain",
        "Замерзающая морось":           "cloud.rain.fill",
        "Сильная замерзающая морось":   "cloud.rain.fill",
        "Местами небольшой дождь":      "sun.max",
        "Небольшой дождь":              "cloud.rain",
        "Временами умеренный дождь":    "cloud.rain",
        "Умеренный дождь":              "cloud.rain",
        "Временами сильный дождь":      "cloud.heavyrain",
        "Сильный дождь":                "cloud.heavyrain.fill",
        "Слабый переохлажденный дождь": "cloud.heavyrain.fill"
    ]
    
    private static let weatherImagesForCode = [
        113 : "sun.max",
        116 : "cloud.sun",
        119 : "cloud",
        122 : "cloud.drizzle",
        143 : "cloud.fog",
        176 : "cloud.rain",
        179 : "cloud.snow",
        182 : "cloud.snow.fill",
        185 : "cloud.drizzle",
        200 : "cloud.bolt",
        227 : "cloud.bolt.rain",
        230 : "cloud.bol.rain",
        248 : "cloud.fog",
        260 : "cloud.fog",
        263 : "cloud.drizzle",
        266 : "cloud.drizzle",
        281 : "cloud.drizzle",
        284 : "cloud.drizzle",
        293 : "cloud.rain",
        296 : "cloud.rain",
        299 : "cloud.rain",
        302 : "cloud.rain",
        305 : "cloud.heavyrain",
        308 : "cloud.heavyrain.fill",
        311 : "cloud.hail",
        314 : "cloud.hail.fill",
        317 : "cloud.hail",
        320 : "cloud.hail.fill",
        323 : "cloud.snow",
        326 : "cloud.snow",
        329 : "cloud.snow.fill",
        332 : "cloud.snow.fill",
        335 : "cloud.snow.fill",
        338 : "cloud.snow.fill",
        350 : "cloud.sleet",
        353 : "cloud.drizzle",
        356 : "cloud.rain",
        359 : "cloud.heavyrain",
        362 : "cloud.sleet",
        365 : "cloud.sleet.fill",
        368 : "cloud.sleet",
        371 : "cloud.sleet.fill",
        374 : "cloud.hail",
        377 : "cloud.hail.fill",
        386 : "cloud.bolt.rain",
        389 : "cloud.bolt.rain.fill",
        392 : "cloud.bolt.rain",
        395 : "cloud.bolt.rain.fill"
    ]
}
