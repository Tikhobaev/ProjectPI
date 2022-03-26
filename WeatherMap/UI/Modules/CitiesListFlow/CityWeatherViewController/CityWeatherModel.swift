//
//  CityWeatherModel.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 12.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

struct CityWeatherModel: Hashable, Equatable {
    
    var cityName: String
    var humidity: String
    var windSpeed: String
    var tempC: String
    var weatherCode: String
    var weatherDescription: String
    var weekdaysWeather: [WeekdayWeatherModel]
    
    var windSpeedMPSDescription: String {
        guard let speedKmPH = Double(windSpeed) else {
            return windSpeed
        }
        let speedMPS = Int(round(speedKmPH / 3.6))
        return "\(speedMPS) м/с"
    }
    
    init(cityWeatherEntity: CityWeatherEntity) {
        
        self.cityName = cityWeatherEntity.cityName
        self.humidity = cityWeatherEntity.humidity
        self.tempC = cityWeatherEntity.tempC
        self.weatherCode = cityWeatherEntity.weatherCode
        self.weatherDescription = cityWeatherEntity.weatherDescription
        self.windSpeed = cityWeatherEntity.windspeedKmph
        
        guard let weekdaysWeatherEntities = cityWeatherEntity.weekdaysWeather.allObjects as? [WeekDayWeatherEntity] else {
            self.weekdaysWeather = []
            return
        }
        
        var weekdaysWeatherModels = weekdaysWeatherEntities.map {
            WeekdayWeatherModel(weekdayWeatherEntity: $0)
        }
        
        weekdaysWeatherModels.sort {
            $0.date < $1.date
        }
        
        self.weekdaysWeather = weekdaysWeatherModels
        
    }
}
