//
//  NetworkLogger.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//
//  Inspiered by:
//  https://www.avanderlee.com/swift/printing-data-requests/

import Foundation

final class URLLogger: URLProtocol {
    
    override public class func canInit(with request: URLRequest) -> Bool {
        
        print("? Running request: \(request.httpMethod ?? "") - \(request.url?.absoluteString ?? "")")
        
        // By returning `false`, this URLProtocol will do nothing less than logging.
        return false
    }
}
