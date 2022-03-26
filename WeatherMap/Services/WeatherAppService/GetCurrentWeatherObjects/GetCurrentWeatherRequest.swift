//
//  GetCurrentWeatherRequest.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//

import Foundation

struct GetCurrentWeatherRequest: NetworkRequest {
    var apiPath: String = WeatherAppService.baseUrlString
    var apiResource: String = "weather"
    var requestType: HTTPMethod = .get
    var urlParameters: Dictionary<String, String>?
    
    init(lattitude: String, longtitude: String) {
        urlParameters = [:]
        urlParameters?["lat"] = lattitude
        urlParameters?["lon"] = longtitude
        urlParameters?["appid"] = WeatherAppService.apiKey
        urlParameters?["units"] = "metric"
        urlParameters?["lang"] = "ru"
    }
}
