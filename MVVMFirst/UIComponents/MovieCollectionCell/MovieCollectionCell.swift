//
//  MovieCollectionCell.swift
//  MVVMFirst
//
//  Created by Алексей on 09.01.2021.
//

import UIKit
import RxSwift
import EasyPeasy

final class MovieCollectionCell: UICollectionViewCell {
    
    private let imageView = UIImageView(frame: .zero)
    private let viewModel = MovieCellViewModelAssembly.getMovieCellViewModel()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func putImage(url: String) {
        viewModel.getImage(url: "\(Constants.photoBaseUrl)\(url)")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image): self.imageView.image = image
                case .failure(_): self.imageView.image = #imageLiteral(resourceName: "errorImage")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        setupImage()
    }
    
    private func setupImage() {
        contentView.addSubview(imageView)
        imageView.easy.layout(Top(0),
                          Leading(0),
                          Trailing(0),
                          Bottom(0))
        imageView.contentMode = .scaleAspectFill
    }
}

extension MovieCollectionCell {
    enum Constants {
        static let photoBaseUrl = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/"
    }
}

