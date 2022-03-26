//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

//  Inspaered by:
//  https://medium.com/better-programming/highly-customizable-network-layer-in-swift-5-1e5c1e163674
//  but reworked totaly

import Foundation

final class NetworkClient: NSObject {
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 15.0
        configuration.urlCache = nil
        configuration.protocolClasses?.insert(LoggingURLProtocol.self, at: 0)
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        LoggingURLProtocol.sessionDelegate = session.delegate
        
        return session
        
    }()
    
    static let shared = NetworkClient()
    private override init() {
        super.init()
    }
    
    private var dataTask: URLSessionDataTask?
    
    func callApi(_ request: NetworkRequest, completion: @escaping (Result<NetworkResponse,Error>) -> Void) {
        let urlRequest = urlRequestWith(apiRequest: request)
        dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                if let retry = request.retry, retry.currentTry < retry.maxRetries {
                    retry.currentTry += 1
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + retry.delay) {
                        self.callApi(request, completion: completion)
                    }
                } else {
                    completion(.failure(error))
                }
            } else {
                completion(.success((response, data)))
            }
        }
        dataTask?.resume()
    }
    
    // TODO: move to Backend
    func urlRequestWith(apiRequest: NetworkRequest) -> URLRequest {
        let completeUrl = apiRequest.webServiceUrl +
            apiRequest.apiPath +
            apiRequest.apiVersion +
            apiRequest.apiResource +
            apiRequest.endPoint
        
        var components = URLComponents(string: completeUrl)!
        if let urlParams = apiRequest.urlParameters {
            var queryItems = [URLQueryItem]()
            urlParams.forEach({ (key, value) in
                let queryItem = URLQueryItem(name: key, value: String(value))
                queryItems.append(queryItem)
            })
            components.queryItems = queryItems
        }
        
        let url = components.url! // URL(string: completeUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.requestType.rawValue
        urlRequest.setValue(apiRequest.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = apiRequest.body
        
        apiRequest.headers?.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        
        return urlRequest
    }
}

extension NetworkClient: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        switch challenge.protectionSpace.host {
            default:
                completionHandler(.performDefaultHandling, nil)
        }
    }
}
