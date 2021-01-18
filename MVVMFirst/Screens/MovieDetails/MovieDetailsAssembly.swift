//
//  MovieDetailsAssembly.swift
//  MVVMFirst
//
//  Created by Алексей on 18.01.2021.
//

import Foundation

enum MovieDetailsAssembly {
    static func assemble(movieItem: MovieCollectionItem) -> MovieDetailsViewController {
        let coreDataStack = CoreDataStack.shared
        let networkService = NetworkService()
        let imageDownloader = ImageDownloader()
        let repository = MainRepository(coreDataStack: coreDataStack, networkService: networkService, imageDownloader: imageDownloader)
        let viewModel = MovieDetailsViewModel(movieItem: movieItem, repository: repository)
        return MovieDetailsViewController(viewModel: viewModel)
    }
}
