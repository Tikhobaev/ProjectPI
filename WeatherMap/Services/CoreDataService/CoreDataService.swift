//
//  CoreDataService.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 10.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation
import CoreData

//MARK: EntitiesEnum

enum Entities {
   
}


//MARK: ServiceProtocol

protocol CoreDataServiceable {
    
    static var shared: CoreDataService { get }

}

//MARK: General

final class CoreDataService: NSObject, CoreDataServiceable {
    
    
    // MARK: Singleton
    static let shared = CoreDataService()
    private override init() {
        super.init()
        
    }
    
    
    // MARK: Methods
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: CoreDataService.backgroundContext)!
    }
    
    func getCurrentLocationWeatherEntity() -> CurrentLocationWeatherEntity? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CurrentLocationWeatherEntity.fetchRequest()
        let context = CoreDataService.backgroundContext
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects.first as? CurrentLocationWeatherEntity
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return nil
    }
    
    func getCitiesWeatherEntities() -> [CityWeatherEntity]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CityWeatherEntity.fetchRequest()
        let context = CoreDataService.backgroundContext
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects as? [CityWeatherEntity]
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return nil
    }
    
    func isCityWeatherEntityInCoreData(for cityName: String) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CityWeatherEntity.fetchRequest()
        let context = CoreDataService.backgroundContext
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return false
            }
            guard let citiesWeatherEntities = objects as? [CityWeatherEntity] else {
                return false
            }
            
            return citiesWeatherEntities.contains { (cityWeatherEntity) -> Bool in
                cityWeatherEntity.cityName == cityName
            }
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return false
    }
    
    func getWeekdaysWeatherForCurrentLocation(currentLocationWeatherEntity: CurrentLocationWeatherEntity) -> [WeekDayWeatherEntity]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WeekDayWeatherEntity.fetchRequest()
        let context = CoreDataService.backgroundContext
        
        fetchRequest.predicate = NSPredicate(format: "currentLocationWeather == %@", currentLocationWeatherEntity)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects as? [WeekDayWeatherEntity]
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return nil
    }
    
    
    func saveChanges() {
        saveBackgroundContext()
    }
    
    func removeCityWeatherEntity(for cityName: String) {
        
        let context = CoreDataService.backgroundContext
        
        let deleteFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityWeatherEntity")
        deleteFetchRequest.predicate = NSPredicate.init(format: "cityName == %@",  cityName)
        
        do {
            let objects = try context.fetch(deleteFetchRequest) as? [NSManagedObject]
            objects?.forEach(context.delete)
        } catch {
            let fetchError = error as NSError
            print("Unable to Delete Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        saveChanges()
        
    }
    
    public func clearAllCoreData() {
        let entities = CoreDataService.persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }
    
    private func clearDeepObjectEntity(_ entity: String) {
        let context = CoreDataService.backgroundContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    private func saveBackgroundContext() {
        let context = CoreDataService.backgroundContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - FetchedResultsControllers
    
   
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "WeatherAppDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //static var mainContext = CoreDataService.persistentContainer.viewContext
    static var backgroundContext = CoreDataService.persistentContainer.newBackgroundContext()
    
}
