//
//  DBManager.swift
//  SmartMovie
//
//  Created by BachNguyen on 01/04/2023.
//

import Foundation
import CoreData

final class DBManager {
    static let shared: DBManager = DBManager()
    private let modelName: String = "SmartMovie"
    private let favouriteEntity: String = "Favourite"
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { ( _, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    func addFavourite(idMovie: Int32) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: favouriteEntity, into: managedObjectContext)
        guard let favourite = entity as? Favourite else {
            fatalError("Error: Failed to create a new object")
        }
        favourite.idMovie = idMovie
        saveContext()
    }
    func getFavourite(idMovie: Int32) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: favouriteEntity)
        fetchRequest.predicate = NSPredicate(format: "idMovie == %@", NSNumber(value: idMovie))
        fetchRequest.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            fatalError("Failed to get favourite movie: \(error)")
        }
    }
    func deleteFavourite(idMovie: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: favouriteEntity)
        fetchRequest.predicate = NSPredicate(format: "idMovie == %@", NSNumber(value: idMovie))
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let entity = results.first as? Favourite {
                managedObjectContext.delete(entity)
                saveContext()
            }
        } catch {
            fatalError("Failed to delete favourite movie: \(error)")
        }
    }
}
