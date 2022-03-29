import Foundation

struct GetWeatherRequest: NetworkRequest {
    var apiPath: String = WeatherAppService.baseUrlString
    var apiResource: String = "weather"
    var urlParameters: Dictionary<String, String>?
    
    init(lattitude: String, longtitude: String, apiKey: String) {
        self.urlParameters = [
            "q": "\(lattitude),\(longtitude)",
            "num_of_days": "7",
            "format": "JSON",
            "key": apiKey,
            "lang": "ru",
            "mca": "no",
            "includelocation": "yes"
        ]
    }
}
