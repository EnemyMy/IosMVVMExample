//
//  MovieCollectionCellAssembly.swift
//  MVVMFirst
//
//  Created by Алексей on 09.01.2021.
//

import Foundation

enum MovieCellViewModelAssembly {
    static func getMovieCellViewModel() -> MovieCellViewModelHolder {
        let coreDataStack = CoreDataStack.shared
        let networkService = NetworkService()
        let imageDownloader = ImageDownloader()
        let repository = MainRepository(coreDataStack: coreDataStack, networkService: networkService, imageDownloader: imageDownloader)
        return MovieCellViewModel(repository: repository)
    }
}
