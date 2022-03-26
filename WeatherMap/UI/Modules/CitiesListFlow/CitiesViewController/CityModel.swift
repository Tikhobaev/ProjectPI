//
//  CityModel.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 12.10.2020.
//

import Foundation

struct CityModel: Hashable {
    
    let name: String
    let weatherDescription: String
    let maxTemperature: String
    let minTemperature: String
    let weatherCode: String
    
    init(entity: CityWeatherEntity) {
        name = entity.cityName
        weatherDescription = entity.weatherDescription
        let weekdaysWeather = entity.weekdaysWeatherArray
        maxTemperature = weekdaysWeather.first?.maxTempC ?? ""
        minTemperature = weekdaysWeather.first?.minTempC ?? ""
        weatherCode = entity.weatherCode
    }
}
