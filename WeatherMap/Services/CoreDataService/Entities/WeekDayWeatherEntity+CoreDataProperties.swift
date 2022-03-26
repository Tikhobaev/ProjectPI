//
//  WeekDayWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 12.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension WeekDayWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekDayWeatherEntity> {
        return NSFetchRequest<WeekDayWeatherEntity>(entityName: "WeekDayWeatherEntity")
    }

    @NSManaged public var avgTempC: String
    @NSManaged public var date: Date
    @NSManaged public var maxTempC: String
    @NSManaged public var minTempC: String
    @NSManaged public var weatherCode: String
    @NSManaged public var weatherDescription: String
    @NSManaged public var cityWeather: CityWeatherEntity?
    @NSManaged public var currentLocationWeather: CurrentLocationWeatherEntity?
    
    convenience init(weekdayResponse: Weather) {
        self.init(entity: CoreDataService.shared.entityForName(entityName: "WeekDayWeatherEntity"), insertInto: CoreDataService.backgroundContext)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        self.date = formatter.date(from: weekdayResponse.date) ?? Date()
        
        self.weatherCode = weekdayResponse.hourly.first?.weatherCode ?? "000"
        self.weatherDescription = weekdayResponse.hourly.first?.lang_ru.first?.value ?? "No description"
        self.weatherCode = weekdayResponse.hourly.first?.weatherCode ?? "No weather code"
        self.avgTempC = weekdayResponse.avgtempC
        self.minTempC = weekdayResponse.mintempC
        self.maxTempC = weekdayResponse.maxtempC
    }

}

extension WeekDayWeatherEntity : Identifiable {

}
