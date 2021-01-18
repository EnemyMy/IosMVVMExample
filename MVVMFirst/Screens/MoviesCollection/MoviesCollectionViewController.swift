//
//  ViewController.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import EasyPeasy

final class MoviesCollectionViewController: UIViewController {
    
    var collectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    private let viewModel: MoviesCollectionViewModelHolder
    private let disposeBag = DisposeBag()
    
    init(viewModel: MoviesCollectionViewModelHolder) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubscribe()
        viewModel.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    private func setupViews() {
        setupNavigationView()
        setupActivityIndicator()
        setupCollectionView()
    }
    
    private func setupNavigationView() {
        title = "Popular Movies"
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        activityIndicator.easy.layout(CenterX(), CenterY())
    }
    
    private func setupCollectionView() {
        let layout = StaggeredCollectionViewLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionCell.self)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        layout.delegate = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.easy.layout(Top(0).to(view.safeAreaLayoutGuide, .top),
                                   Leading(0).to(view.safeAreaLayoutGuide, .leading),
                                   Trailing(0).to(view.safeAreaLayoutGuide, .trailing),
                                   Bottom(0).to(view.safeAreaLayoutGuide, .bottom))
    }
    
    private func setupSubscribe() {
        setupAlertSubscribe()
        setupMoviesSubscribe()
    }
    
    private func setupAlertSubscribe() {
        viewModel.alertPublisher.subscribe(onNext: { [weak self] alertData in
            guard let self = self else { return }
            let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: alertData.style)
            alertData.actions.map { $0.mapToUIAlertAction() }.forEach { alert.addAction($0) }
            self.present(alert, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    private func setupMoviesSubscribe() {
        viewModel.movies
            .debug(nil, trimOutput: true)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: UICollectionViewDataSource

extension MoviesCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.deque(MovieCollectionCell.self, for: indexPath) else { fatalError() }
        cell.shadowDecorate(shadowOffset: CGSize(width: -3, height: 3))
        let url = viewModel.movies.value[indexPath.row].poster_path
        cell.putImage(url: url)
        return cell
    }
}

//MARK: StaggeredCollectionViewLayoutDelegate

extension MoviesCollectionViewController: StaggeredCollectionViewLayoutDelegate {
    
    func numberOfColumnsInCollectionView(_ collectionView: UICollectionView) -> Int {
        2
    }
    
    func lineSpacingInCollectionView(_ collectionView: UICollectionView) -> Int {
        6
    }
    
    func interitemSpacingInCollectionView(_ collectionView: UICollectionView) -> Int {
        6
    }
}

//MARK: UICollectionViewDelegate

extension MoviesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.movies.value[indexPath.item]
        let vc = MovieDetailsAssembly.assemble(movieItem: item)
        present(vc, animated: true)
    }
}

