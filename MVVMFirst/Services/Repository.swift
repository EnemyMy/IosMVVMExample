//
//  Repository.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import Foundation
import RxSwift
import CoreData

protocol Repository {
    func fetchMovies() -> Observable<Result<[ManagedMovie], Error>>
    
    func getImage(url: String) -> Observable<Result<UIImage, Error>>
}

final class MainRepository: Repository {
    
    let coreDataStack: CoreDataStack
    let networkService: NetworkService
    let imageDownloader: ImageDownloader
    
    init(coreDataStack: CoreDataStack, networkService: NetworkService, imageDownloader: ImageDownloader) {
        self.coreDataStack = coreDataStack
        self.networkService = networkService
        self.imageDownloader = imageDownloader
    }
    
    func fetchMovies() -> Observable<Result<[ManagedMovie], Error>> {
        coreDataStack.deleteAllMovies()
        return networkService.makeRequest()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                if case let .success(value) = result {
                    self.coreDataStack.insert(value)
                    self.coreDataStack.saveContext()
                }
            })
            .flatMap { [weak self] result -> Observable<Result<[ManagedMovie], Error>> in
                guard let self = self else { return Observable.empty() }
                let request: NSFetchRequest<ManagedMovie> = ManagedMovie.fetchRequest()
                return CDObservable(request: request, context: self.coreDataStack.context).map { Result.success($0) }.asObservable()
            }
            .catchError {
                Observable.just(Result.failure($0))
            }
    }
    
    func getImage(url: String) -> Observable<Result<UIImage, Error>> {
        imageDownloader.getImage(url)
    }
}
