//
//  MeasurementFormatter+Kilowatts.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 04.05.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//
//  Inspiered by:
//  https://medium.com/@pwilko/scaling-measurement-in-swift-71f3c1856458

import Foundation

class PowerMeasurementFormatter: MeasurementFormatter {
    
    override init() {
        super.init()
        
        self.unitOptions = .providedUnit
        self.unitStyle = .short
        self.locale = Locale(identifier: "en_FR")
        self.numberFormatter.decimalSeparator = "."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func kilowatts(_ power: Double?) -> String? {
        guard let power = power else {
            return nil
        }
        
        if power == 0 {
            return "0"
        }
        
        let energyValue = Measurement(value: power, unit: UnitEnergy.kilowattHours)
        
        let scaledEnergy = energyValue.scaled(scales: [
            .wattHours,
            .kilowattHours,
            .megaWattHours,
            .gigaWattHours
        ], target: 500)
        return string(from: scaledEnergy)
    }
    
}

extension Measurement where UnitType: Dimension {
    
    /// Attempt to find a  `UnitType` that produces a value less than `target`
    ///
    /// See [Scaling Measurement in Swift](https://wilko.me/wordpress/?p=371)
    /// - Parameters:
    ///   - scales: An array of `UnitTypes` that will be applied in order seeking a value less than `target`.  \
    ///   This array should be in increasing order of coefficient
    ///   - target: The target value
    /// - Returns:
    ///   `Self` converted to the `UnitType` that produces a value less than `target` or
    ///   scaled by the last `UnitType` in the `scales` array
    
    func scaled (scales:[UnitType], target: Double) -> Measurement {
        guard !scales.isEmpty else {
            return self
        }
        var returnMeasure = self.converted(to: scales.first!)
        if returnMeasure.value.magnitude > target {
            
            for unit in scales {
                returnMeasure.convert(to: unit)
                if returnMeasure.value.magnitude < target {
                    break
                }
            }
        }
        return returnMeasure
    }
}

extension UnitEnergy {

    static let wattHours =
        UnitEnergy(symbol: "Wh", converter: UnitConverterLinear(coefficient:3600))
    
    static let megaWattHours =
        UnitEnergy(symbol: "mWh", converter: UnitConverterLinear(coefficient:3600000000))
    
    static let gigaWattHours =
        UnitEnergy(symbol: "gWh", converter: UnitConverterLinear(coefficient:3600000000000))
    
}
