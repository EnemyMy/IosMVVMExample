//
//  CoreDataStack.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import Foundation
import CoreData
import RxSwift

final class CoreDataStack {
    var container = NSPersistentContainer(name: Constants.modelName)
    lazy var context = container.viewContext
    
    static let shared = CoreDataStack()
    
    private init() {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func insert(_ movies: [Movie]) -> [ManagedMovie] {
        let movies = movies.compactMap { $0.mapToManagedMovie(context: context) }
        return movies
    }
    
    func deleteAllMovies() {
        let fetchRequest = ManagedMovie.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        deleteRequest.affectedStores = container.persistentStoreCoordinator.persistentStores
        
        do {
            try context.execute(deleteRequest)
            context.refreshAllObjects()
        } catch {
            print("Failed to delete movies. Error: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context. Error: \(error.localizedDescription)")
        }
    }
}

extension CoreDataStack {
    enum Constants {
        static let modelName = "MVVMFirst"
    }
}
