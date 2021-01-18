//
//  MovieDetailsViewModel.swift
//  MVVMFirst
//
//  Created by Алексей on 18.01.2021.
//

import Foundation
import RxSwift
import RxRelay

protocol MovieDetailsViewModelHolder {
    //required
    var movie: BehaviorRelay<MovieCollectionItem> { get }
    func getImage(url: String) -> Observable<Result<UIImage, Error>>
    
    //optional
    func viewDidLoad()
    func viewDidAppear()
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

//MARK: MovieDetailsViewModelHolder Optional

extension MovieDetailsViewModelHolder {
    func viewDidLoad() {}
    func viewDidAppear() {}
    func viewWillAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

final class MovieDetailsViewModel: MovieDetailsViewModelHolder {
    
    let movie: BehaviorRelay<MovieCollectionItem>
    
    private let repository: Repository
    
    init(movieItem: MovieCollectionItem, repository: Repository) {
        self.movie = BehaviorRelay(value: movieItem)
        self.repository = repository
    }
    
    func getImage(url: String) -> Observable<Result<UIImage, Error>> {
        repository.getImage(url: url)
    }
}
