import Foundation

final class CityWeatherViewModel: BaseViewModel {
    
    var cityWeatherModel: CityWeatherModel?
    
    override init() {
        super.init()
    
    }
    
    init(cityWeatherModel: CityWeatherModel?) {
        self.cityWeatherModel = cityWeatherModel
    }
    
}

extension CityWeatherViewModel: CityWeatherViewModeling {
    
}
