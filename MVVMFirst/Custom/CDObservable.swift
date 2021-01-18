//
//  CDObservable.swift
//  MVVMFirst
//
//  Created by Алексей on 02.01.2021.
//

import Foundation
import CoreData
import RxSwift

final class CDObservable<T>: NSObject, ObservableType, NSFetchedResultsControllerDelegate where T: NSManagedObject {
    
    typealias Element = [T]
    
    let fetchRequest: NSFetchRequest<T>
    private let fetchController: NSFetchedResultsController<T>
    private let publisher = BehaviorSubject<Element>(value: [])
    
    init(request: NSFetchRequest<T>, context: NSManagedObjectContext) {
        request.sortDescriptors = []
        self.fetchRequest = request
        self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchController.delegate = self
        do {
            try fetchController.performFetch()
            controllerDidChangeContent(fetchController as! NSFetchedResultsController<NSFetchRequestResult>)
        } catch  {
            print("Error in fetch controller trying to perform fetch. Error: \(error)")
        }
    }
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
        publisher.subscribe(observer)
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let fetchedObjects = controller.fetchedObjects as? [T] ?? []
        print(fetchedObjects.count)
        publisher.onNext(fetchedObjects)
    }
    
}

