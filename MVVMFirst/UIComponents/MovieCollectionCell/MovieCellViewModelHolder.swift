//
//  MovieCellViewModel.swift
//  MVVMFirst
//
//  Created by Алексей on 09.01.2021.
//

import Foundation
import RxSwift

protocol MovieCellViewModelHolder {
    func getImage(url: String) -> Observable<Result<UIImage, Error>>
}

final class MovieCellViewModel: MovieCellViewModelHolder {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func getImage(url: String) -> Observable<Result<UIImage, Error>> {
        repository.getImage(url: url)
    }
}
