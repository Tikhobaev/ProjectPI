import Foundation

struct WeekdayWeatherModel: Hashable, Equatable {
    
    var date: Date
    var weatherDescription: String
    var avgTempC: String
    var minTempC: String
    var weatherCode: String
   
    init(weekdayWeatherEntity: WeekDayWeatherEntity) {
        
        self.date = weekdayWeatherEntity.date
        self.weatherDescription = weekdayWeatherEntity.weatherDescription
        self.avgTempC = weekdayWeatherEntity.avgTempC
        self.minTempC = weekdayWeatherEntity.minTempC
        self.weatherCode = weekdayWeatherEntity.weatherCode
        
    }
}
