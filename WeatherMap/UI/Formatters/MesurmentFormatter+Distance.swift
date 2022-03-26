//
//  MesurmentFormatter+Distance.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 04.05.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//

import Foundation

class DistanceMesurmentFormatter: MeasurementFormatter {
    
    override init() {
        super.init()
        
        self.unitOptions = .naturalScale
        self.unitStyle = .short
        self.locale = Locale(identifier: "en_FR")
        self.numberFormatter.decimalSeparator = "."
        self.numberFormatter.maximumFractionDigits = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func distance(meters: Double?) -> String? {
        guard let meters = meters else {
            return nil
        }
        
        if meters == 0 {
            return ""
        }
       
        let distance = Measurement(value: meters, unit: UnitLength.meters)
        let distanceString = string(from: distance)
        
        return distanceString
    }
    
    func distance(kilometers: Double?) -> String? {
        guard let kilometers = kilometers else {
            return nil
        }
        
        if kilometers == 0 {
            return ""
        }
       
        let distance = Measurement(value: kilometers, unit: UnitLength.kilometers)
        let distanceString = string(from: distance)
        
        return distanceString
    }
}

