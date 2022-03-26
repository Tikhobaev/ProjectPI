//
//  CurrentLocationWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 12.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentLocationWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentLocationWeatherEntity> {
        return NSFetchRequest<CurrentLocationWeatherEntity>(entityName: "CurrentLocationWeatherEntity")
    }

    @NSManaged public var cityName: String
    @NSManaged public var humidity: String
    @NSManaged public var tempC: String
    @NSManaged public var weatherCode: String
    @NSManaged public var weatherDescription: String
    @NSManaged public var windspeedKmph: String
    @NSManaged public var weekdaysWeather: NSSet
    
    convenience init(weatherResponse: GetWeatherResponse) {
        self.init(entity: CoreDataService.shared.entityForName(entityName: "CurrentLocationWeatherEntity"), insertInto: CoreDataService.backgroundContext)
        
        self.cityName = weatherResponse.nearest_area?.first?.region?.first?.value.description ?? "No name"
        self.tempC = weatherResponse.current_condition.first?.temp_C ?? "No temp"
        self.humidity = weatherResponse.current_condition.first?.humidity ?? "No info"
        self.weatherDescription = weatherResponse.current_condition.first?.lang_ru.first?.value ?? "No description"
        self.weatherCode = weatherResponse.current_condition.first?.weatherCode ?? "No weather code"
        self.windspeedKmph = weatherResponse.current_condition.first?.windspeedKmph ?? "No windspeed"
        
        for weekdayWeather in weatherResponse.weather {
            addToWeekdaysWeather(WeekDayWeatherEntity(weekdayResponse: weekdayWeather))
        }
    }
    
    func updateValues(from weatherResponse: GetWeatherResponse) {
       
        self.cityName = weatherResponse.nearest_area?.first?.region?.first?.value.description ?? "No name"
        self.tempC = weatherResponse.current_condition.first?.temp_C ?? "No temp"
        self.humidity = weatherResponse.current_condition.first?.humidity ?? "No info"
        self.weatherDescription = weatherResponse.current_condition.first?.lang_ru.first?.value ?? "No description"
        self.weatherCode = weatherResponse.current_condition.first?.weatherCode ?? "No weather code"
        
        self.removeFromWeekdaysWeather(weekdaysWeather)
        
        for weekdayWeather in weatherResponse.weather {
            addToWeekdaysWeather(WeekDayWeatherEntity(weekdayResponse: weekdayWeather))
        }
    }

}

// MARK: Generated accessors for weekdaysWeather
extension CurrentLocationWeatherEntity {

    @objc(addWeekdaysWeatherObject:)
    @NSManaged public func addToWeekdaysWeather(_ value: WeekDayWeatherEntity)

    @objc(removeWeekdaysWeatherObject:)
    @NSManaged public func removeFromWeekdaysWeather(_ value: WeekDayWeatherEntity)

    @objc(addWeekdaysWeather:)
    @NSManaged public func addToWeekdaysWeather(_ values: NSSet)

    @objc(removeWeekdaysWeather:)
    @NSManaged public func removeFromWeekdaysWeather(_ values: NSSet)

}

extension CurrentLocationWeatherEntity : Identifiable {

}
