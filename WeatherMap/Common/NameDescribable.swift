//
//  NameDescribable.swift
//  WeatherApp
//
//  Created by Андрей Журавлев on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        String(describing: type(of: self))
    }
    
    static var typeName: String {
        String(describing: self)
    }
    
}
