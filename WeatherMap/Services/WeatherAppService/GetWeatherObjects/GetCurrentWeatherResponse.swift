//
//  GetCurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

// MARK: - GetWeatherResponse
struct GetWeatherResponse: Codable {
    let request: [Request]
    let nearest_area: [NearestArea]?
    let current_condition: [CurrentCondition]
    let weather: [Weather]
}

// MARK: - CurrentCondition

//NOTE: for some reason all decimal numbers from server comes as String rather than Int or Float etc
struct CurrentCondition: Codable {
    /// The temperature in degrees Celsius
    let temp_C: String
    
    /// Feels like temperature in degrees Celsius
    let FeelsLikeC: String
    
    /// Weather condition code
    let weatherCode: String
    
    /// Weather condition description
    let weatherDesc: [DescriptionObject]
    
    /// Weather condition description localized in Russian
    let lang_ru: [DescriptionObject]
    
    /// Wind speed in kilometres per hour
    let windspeedKmph: String
    
    /// Wind direction in 16-point compass
    let winddir16Point: String
    
    /// Precipitation (осадки) in millimetres
    let precipMM: String
    
    /// Humidity in percentage
    let humidity: String
    
    /// Visibility in kilometres
    let visibility: String
    
    /// Atmospheric pressure in millibars
    let pressure: String
    
    /// Cloud cover in percentage
    let cloudcover: String
}

// MARK: - LangRu
struct DescriptionObject: Codable {
    let value: String
}

// MARK: - NearestArea
struct NearestArea: Codable {
    let latitude: String
    let longitude: String
    let areaName: [DescriptionObject]?
    let country: [DescriptionObject]?
    let region: [DescriptionObject]?
    let population: String?
    let weatherUrl: [DescriptionObject]?
}

// MARK: - Request
struct Request: Codable {
    let type, query: String
}

// MARK: - Weather
struct Weather: Codable {
    let date: String
    /// Astronomical condition for the day
    let maxtempC: String
    let mintempC: String
    let avgtempC: String
    let sunHour: String
    let uvIndex: String
    let hourly: [Hourly]
    
}

// MARK: - Hourly
struct Hourly: Codable {
    let lang_ru: [DescriptionObject]
    let time: String
    let tempC: String
    let windspeedKmph: String
    let winddir16Point: String
    let weatherCode: String
    let precipMM: String
    let humidity: String
    let visibility: String
    let pressure: String
    let cloudcover: String
    let FeelsLikeC: String
    let chanceofrain: String
    let chanceofsnow: String
}

