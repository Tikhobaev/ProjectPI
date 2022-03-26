//
//  WeatherAppService.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

final class WeatherAppService {
    
    static let baseUrlString = "https://api.worldweatheronline.com/premium/v1/weather.ashx/"
    internal static let apiKey = "a1a927bc65a94340b0591955200910"
    
    static let shared = WeatherAppService()
    private init() {}
    
    func makeRequestAndParseResponce<T: Codable>(_ request: NetworkRequest, completion: @escaping (Result<T?, WeatherAppServerError>) -> Void) {
        
        NetworkClient.shared.callApi(request) { apiResponse in
            let httpStatusResult = self.checkHttpStatusCode(apiResponse)
            switch httpStatusResult {
                case .success(let data):
                    let backendResponse: Result<T?, WeatherAppServerError> = self.parseApiResponce(data)
                    completion(backendResponse)
                case .failure(let error):
                    completion(.failure(.network(error)))
            }
        }
    }
    
    // For cases when responce is not needed to be parsed
    func makeRequest(_ request: NetworkRequest, completion: @escaping ((Error?) -> Void)) {
        NetworkClient.shared.callApi(request) { apiResponse in
            let httpStatusResult = self.checkHttpStatusCode(apiResponse)
            switch httpStatusResult {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func checkHttpStatusCode(_ apiResponse: Result<NetworkResponse, Error>) -> Result<Data?, Error> {
        switch apiResponse {
            case .success((let urlResponce, let data)):
                guard let urlResponce = urlResponce as? HTTPURLResponse else {
                    return .failure(WeatherAppServerError.server("No response found"))
                }
                
                switch urlResponce.statusCode {
                    case 200...299:
                        return .success(data)
      
                    default:
                        return .failure(WeatherAppServerError.server("Some error"))
                }
                
            case .failure(let error):
                return .failure(error)
        }
    }
    
    func parseApiResponce<T: Codable>(_ data: Data?) -> Result<T?, WeatherAppServerError> {
        guard let data = data else {
            return .failure(.parsing("Response does not have data"))
        }
        
        let parsingResult = WeatherObject<T>.parse(data)
        switch parsingResult {
            case .success(let parsedObject):
                return .success(parsedObject)
            case .failure(let error):
                return .failure(error)
        }
    }
}
