import Foundation

struct GetWeatherForCityRequest: NetworkRequest {
    var apiPath: String = WeatherAppService.baseUrlString
    var apiResource: String = "weather"
    var urlParameters: Dictionary<String, String>?
    
    init(cityName: String, apiKey: String) {
        self.urlParameters = [
            "q": "\(cityName)",
            "num_of_days": "7",
            "format": "JSON",
            "key": apiKey,
            "lang": "ru",
            "mca": "no",
            "includelocation": "yes"
        ]
    }
}
