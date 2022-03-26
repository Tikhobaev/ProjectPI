//
//  SynchronizationService.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 13.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

final class SynchronizationService {
    
    // MARK: Singleton
    static let shared = SynchronizationService()
    private init() {
        
    }
    
    func setupData() {
        WeatherAppService.shared.getWeatherForecast(cityName: "Москва") { result in
            switch result {
            case .success(let response):
                if let response = response {
                    _ = CityWeatherEntity(cityName: "Москва", weatherResponse: response)
                    CoreDataService.shared.saveChanges()
                }
            case .failure(let error):
                switch error {
                case .parsing(_):
                    break
                case .network(_):
                    break
                case .server(_):
                    break
                }
            }
        }
        
        WeatherAppService.shared.getWeatherForecast(cityName: "Минск") { result in
            switch result {
            case .success(let response):
                if let response = response {
                    _ = CityWeatherEntity(cityName: "Минск", weatherResponse: response)
                    CoreDataService.shared.saveChanges()
                }
            case .failure(let error):
                switch error {
                case .parsing(_):
                    break
                case .network(_):
                    break
                case .server(_):
                    break
                }
            }
        }
        
    }
    
    func updateData(completion: ((_ hasInternetConnection:Bool) -> Void)?) {
        
        guard NetworkMonitoringService.shared.isReachable else {
            completion?(false)
            return
        }
        
        let lattitude = LocationService.shared.currentLattitude
        let longtitude = LocationService.shared.currentLongtitude

        WeatherAppService.shared.getWeatherForecast(lattitude: String(lattitude), longtitude: String(longtitude)) { [weak self] (result) in
            guard self != nil else {
                return
            }
            switch result {
            case .success(let response):
                guard let response = response else {
                    return
                }
                
                guard let currentWeatherEntity = CoreDataService.shared.getCurrentLocationWeatherEntity() else {
                    _ = CurrentLocationWeatherEntity(weatherResponse: response)
                    CoreDataService.shared.saveChanges()
                    return
                }
                currentWeatherEntity.updateValues(from: response)
                completion?(true)
                CoreDataService.shared.saveChanges()
                print("saved")
            case .failure(let error):
                print(error)
            }
        }
        
        guard let citiesWeatherEntities = CoreDataService.shared.getCitiesWeatherEntities() else {
            return
        }
        
        for cityWeatherEntity in citiesWeatherEntities{
            WeatherAppService.shared.getWeatherForecast(cityName: cityWeatherEntity.cityName) { result in
                switch result {
                case .success(let response):
                    if let response = response {
                        cityWeatherEntity.updateValues(from: response)
                        CoreDataService.shared.saveChanges()
                    }
                case .failure(let error):
                    switch error {
                    case .parsing(_):
                        break
                    case .network(_):
                        break
                    case .server(_):
                        break
                    }
                }
            }
        }
        
    }
    
}
