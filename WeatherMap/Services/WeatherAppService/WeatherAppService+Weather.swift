//
//  WeatherAppService+Weather.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

typealias GetWeatherCompletionHandler = (Result<GetWeatherResponse?, WeatherAppServerError>) -> ()

protocol WeatherAppServiceWeatherable {
    func getWeatherForecast(lattitude: String, longtitude: String, completion: @escaping GetWeatherCompletionHandler)
    func getWeatherForecast(cityName: String, completion: @escaping GetWeatherCompletionHandler)
}

extension WeatherAppService: WeatherAppServiceWeatherable {
    func getWeatherForecast(lattitude: String, longtitude: String, completion: @escaping GetWeatherCompletionHandler) {
        let request = GetWeatherRequest(lattitude: lattitude, longtitude: longtitude, apiKey: Self.apiKey)
        makeRequestAndParseResponce(request, completion: completion)
    }
    
    func getWeatherForecast(cityName: String, completion: @escaping GetWeatherCompletionHandler) {
        let request = GetWeatherForCityRequest(cityName: cityName, apiKey: Self.apiKey)
        makeRequestAndParseResponce(request, completion: completion)
    }
}
