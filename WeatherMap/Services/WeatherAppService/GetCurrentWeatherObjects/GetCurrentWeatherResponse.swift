//
//  GetCurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//

import Foundation

// MARK: - GetCurrentWeatherResponse
/// response for query current weather at given location
struct GetCurrentWeatherResponse: Codable {
    /// Coordinates
    let coord: Coord
    
    /// Current weather
    let weather: [Weather]
    
    /// Main weather parameteres
    let main: Main
    
    /// Wind parameteres
    let wind: Wind
    
    /// Clouds parameteres
    let clouds: Clouds
    
    /// TIme of data calculations
    let dt: Int
    
    /// Some system info
    let sys: Sys
    
    /// Shift in seconds from UTC
    let timezone: Int
    
    /// City id
    let id: Int
    
    /// City name
    let name: String
    
    // MARK: - Clouds
    struct Clouds: Codable {
        /// Percentage of clouds
        let all: Int
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        let lon, lat: Int
    }
    
    // MARK: - Main
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure, humidity: Int
    }
    
    // MARK: - Sys
    struct Sys: Codable {
        /// Country code e.g "GB"
        let country: String
        
        /// Sunrise time UTC
        let sunrise: Int
        
        /// Sunset time UTC
        let sunset: Int
    }
    
    // MARK: - Weather
    struct Weather: Codable {
        /// Weather condition id
        let id: Int
        
        /// Main condition e.g Rain, Snow, Extreme
        let main: String
        
        /// Localized description, comes in Russian with "lang=ru" query parameter
        let description: String
        
        /// Icon name according to weather
        let icon: String
    }
    
    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Double
        let gust: Double
    }
}
