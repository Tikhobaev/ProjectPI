//
//  NetworkRequest.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var webServiceUrl: String { get }
    var apiPath: String { get }
    var apiVersion: String { get }
    var apiResource: String { get }
    var endPoint: String { get }
    var body: Data? { get }
    var urlParameters: Dictionary<String,String>? { get }
    var requestType: HTTPMethod { get }
    var contentType: String { get }
    var headers: Dictionary<String,String>? { get }
    var retry: Retry? { get }
}

// MARK: - Default Settings
extension NetworkRequest {
    var webServiceUrl: String { "" }
    var apiPath: String { "" }
    var apiVersion: String { "" }
    var apiResource: String { "" }
    var endPoint: String { "" }
    var body: Data? { nil }
    var urlParameters: Dictionary<String,String>? { nil }
    var requestType: HTTPMethod { .get }
    //    var contentType: String { "application/json" }
    var contentType: String { "" }
    var headers: Dictionary<String,String>? { nil }
    var retry: Retry? { nil }
}

class Retry {
    let maxRetries: UInt
    var currentTry: UInt = 1
    let delay: TimeInterval = 0.0
    
    init(_ maxRetries: UInt) {
        self.maxRetries = maxRetries
    }
}
