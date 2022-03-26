//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

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
