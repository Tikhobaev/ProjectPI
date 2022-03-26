//
//  CurrentLocationViewModel.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation
import CoreData

final class CurrentLocationViewModel: BaseViewModel {
    
    var currentLocationWeatherModel: CurrentLocationWeatherModel?
    
    override init() {
        super.init()
        setupFetchedResultsController()
    }
    
    var fetchedResultsController: NSFetchedResultsController<CurrentLocationWeatherEntity>?
    
    private func setupFetchedResultsController() {
        
        let request:NSFetchRequest<CurrentLocationWeatherEntity> = CurrentLocationWeatherEntity.fetchRequest()

        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Failed to fetch results from the database. Handle errors appropriately in your app.
        }
        
        let initialValues = (fetchedResultsController?.fetchedObjects ?? []) as [CurrentLocationWeatherEntity]
        
        guard let currentLocationWeatherEntity = initialValues.first else {
            return
        }
        currentLocationWeatherModel = CurrentLocationWeatherModel(currentLocationWeatherEntity: currentLocationWeatherEntity)
        
    }
    
}

extension CurrentLocationViewModel: CurrentLocationViewModeling {
    
}


extension CurrentLocationViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert, .update:
            guard let currentLocationWeatherEntity = anObject as? CurrentLocationWeatherEntity else {
                return
            }
            currentLocationWeatherModel = CurrentLocationWeatherModel(currentLocationWeatherEntity: currentLocationWeatherEntity)
        case .delete:
            print("delete")
        case .move:
            print("move")
        @unknown default:
            return
        }
        
        didChange?()
        
    }
    
    
}

