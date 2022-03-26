//
//  WeekdayWeatherModel.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 12.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

struct CurrentLocationWeatherModel: Hashable, Equatable {
    
    var cityName: String
    var humidity: String
    var tempC: String
    var weatherCode: String
    var weatherDescription: String
    var windSpeed: String
    var weekdaysWeather: [WeekdayWeatherModel]
    
    var windSpeedMPSDescription: String {
        guard let speedKmPH = Double(windSpeed) else {
            return windSpeed
        }
        let speedMPS = Int(round(speedKmPH / 3.6))
        return "\(speedMPS) м/с"
    }
    
    init(currentLocationWeatherEntity: CurrentLocationWeatherEntity) {
        
        self.cityName = currentLocationWeatherEntity.cityName
        self.humidity = currentLocationWeatherEntity.humidity
        self.tempC = currentLocationWeatherEntity.tempC
        self.weatherCode = currentLocationWeatherEntity.weatherCode
        self.weatherDescription = currentLocationWeatherEntity.weatherDescription
        self.windSpeed = currentLocationWeatherEntity.windspeedKmph
        
        guard let weekdaysWeatherEntities = currentLocationWeatherEntity.weekdaysWeather.allObjects as? [WeekDayWeatherEntity] else {
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
