//
//  MoviesCollectionAssembly.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import Foundation

enum MovieseCollectionAssembly {
    static func assemble() -> MoviesCollectionViewController {
        let coreDataStack = CoreDataStack.shared
        let networkService = NetworkService()
        let imageDownloader = ImageDownloader()
        let repository = MainRepository(coreDataStack: coreDataStack, networkService: networkService, imageDownloader: imageDownloader)
        let viewModel = MoviesCollectionViewModel(repository: repository)
        return MoviesCollectionViewController(viewModel: viewModel)
    }
}
