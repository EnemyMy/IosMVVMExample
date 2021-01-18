//
//  MoviesCollectionViewModel.swift
//  MVVMFirst
//
//  Created by Алексей on 08.01.2021.
//

import Foundation
import RxSwift
import RxRelay

protocol MoviesCollectionViewModelHolder: AlertPublisherHolder, ActivityIndicatorPublisherHolder {
    
    //required
    var movies: BehaviorRelay<[MovieCollectionItem]> { get }
    
    //optional
    func viewDidLoad()
    func viewDidAppear()
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

//MARK: MoviesCollectionViewModelHolder Optional

extension MoviesCollectionViewModelHolder {
    func viewDidLoad() {}
    func viewDidAppear() {}
    func viewWillAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

final class MoviesCollectionViewModel: MoviesCollectionViewModelHolder {

    let alertPublisher = PublishRelay<AlertData>()
    var activityIndicatorPusblisher = PublishRelay<ActivityIndicatorData>()
    let movies = BehaviorRelay<[MovieCollectionItem]>(value: [])
    private let repository: Repository
    private let disposeBag = DisposeBag()
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        self.activityIndicatorPusblisher.accept(ActivityIndicatorData(show: true))
        repository
            .fetchMovies()
            .map { $0.map { $0.map { $0.mapToMovieCollectionItem() } } }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.processResult(result: result, onSuccess: { self.movies.accept($0) })
                self.activityIndicatorPusblisher.accept(ActivityIndicatorData(show: false))
            })
            .disposed(by: disposeBag)
    }
    
    private func processResult<ValueType>(result: Result<ValueType, Error>, onSuccess: (ValueType) -> Void) {
        let onFailure: (Error) -> Void = { [weak self] error in
            guard let self = self else { return }
            let alertData = AlertData(title: "Error",
                                      message: error.localizedDescription,
                                      style: .alert,
                                      actions:[.defaultOkAction, .defaultCloseAction])
            self.alertPublisher.accept(alertData)
        }
        processResult(result: result, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private func processResult<ValueType>(result: Result<ValueType, Error>, onSuccess: (ValueType) -> Void, onFailure: (Error) -> Void) {
        switch result {
        case .success(let value): onSuccess(value)
        case .failure(let error): onFailure(error)
        }
    }
}
