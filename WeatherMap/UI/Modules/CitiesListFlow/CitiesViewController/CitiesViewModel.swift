//
//  CitiesViewModel.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation
import CoreData

final class CitiesViewModel: BaseViewModel {
    
    var citiesWeatherModels: [CityWeatherModel] = []
    var noNetworkConnection: (() -> Void)?
    var didRecieveLocationNotFoundError: (() -> Void)?
    var didAddCitySuccessfully: ((String) -> Void)?
    var didGetEmptyNameForRequest: (() -> Void)?
    var didGetRepeatingCity: (() -> Void)?
    
    var fetchedResultsController: NSFetchedResultsController<CityWeatherEntity>?
    
    override init() {
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        
        let request:NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        
        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
        }
        
        let initialValues = (fetchedResultsController?.fetchedObjects ?? []) as [CityWeatherEntity]
        let initialModels = initialValues.map {
            CityWeatherModel(cityWeatherEntity: $0)
        }
        citiesWeatherModels = initialModels
    }
    
    private func processServerErrorMessage(_ message: String) {
        if message.contains("Unable to find") {
            self.didRecieveLocationNotFoundError?()
        }
    }
}

extension CitiesViewModel: CitiesViewModeling {
    
    func checkAndAddLocation(_ locationName: String) {
        
        guard NetworkMonitoringService.shared.isReachable else {
            self.noNetworkConnection?()
            return
        }
        
        guard locationName.isEmpty == false else {
            self.didGetEmptyNameForRequest?()
            return
        }
        
        guard !CoreDataService.shared.isCityWeatherEntityInCoreData(for: locationName) else {
            self.didGetRepeatingCity?()
            return
        }
        
        isLoading = true
        WeatherAppService.shared.getWeatherForecast(cityName: locationName) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                if let response = response {
                    _ = CityWeatherEntity(cityName: locationName, weatherResponse: response)
                    CoreDataService.shared.saveChanges()
                }
                self?.didAddCitySuccessfully?(locationName)
            case .failure(let error):
                switch error {
                case .parsing(_):
                    break
                case .network(_):
                    break
                case .server(let message):
                    self?.processServerErrorMessage(message)
                }
            }
        }
    }
    
    
}


extension CitiesViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let cityWeatherEntity = anObject as? CityWeatherEntity else {
                return
            }
            citiesWeatherModels.append(CityWeatherModel(cityWeatherEntity: cityWeatherEntity))
        case .update:
            
            guard let cityWeatherEntity = anObject as? CityWeatherEntity else {
                return
            }
            let updatedModel = CityWeatherModel(cityWeatherEntity: cityWeatherEntity)
            
            if let index = self.citiesWeatherModels.firstIndex(where: { $0.cityName == cityWeatherEntity.cityName }) {
                if self.citiesWeatherModels[index].hashValue != updatedModel.hashValue {
                    self.citiesWeatherModels[index] = updatedModel
                }
            } else {
                return
            }
        
        case .delete:
            guard let cityWeatherEntity = anObject as? CityWeatherEntity else {
                return
            }
            
            if let index = self.citiesWeatherModels.firstIndex(where: { $0.cityName == cityWeatherEntity.cityName }) {
                self.citiesWeatherModels.remove(at: index)
            }
        case .move:
            print("move")
        @unknown default:
            return
        }
        
        didChange?()
        
    }
    
    
}

