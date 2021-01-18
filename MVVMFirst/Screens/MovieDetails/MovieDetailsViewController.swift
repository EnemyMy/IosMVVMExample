//
//  MovieDetailsViewController.swift
//  MVVMFirst
//
//  Created by Алексей on 18.01.2021.
//

import UIKit
import RxSwift
import RxRelay
import EasyPeasy

final class MovieDetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var imageUrl = ""
    let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel()
    private let overviewTitleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let popularityTitleLabel = UILabel()
    private let popularityLabel = UILabel()
    private let releaseDateTitleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let voteAverageTitleLabel = UILabel()
    private let voteAverageLabel = UILabel()
    private let voteCountTitleLabel = UILabel()
    private let voteCountLabel = UILabel()
    
    private let viewModel: MovieDetailsViewModelHolder
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieDetailsViewModelHolder) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubscriptions()
        viewModel.viewDidLoad()
    }
    
    //MARK: Private
    
    private func setupViews() {
        view.backgroundColor = .white
        
        setupScrollView()
        [imageView, titleLabel, overviewTitleLabel, overviewLabel, popularityTitleLabel, popularityLabel, releaseDateTitleLabel, releaseDateLabel, voteAverageTitleLabel, voteAverageLabel, voteCountTitleLabel, voteCountLabel].forEach { contentView.addSubview($0) }
        setupImageView()
        setupTitle()
        setupTitleLabels()
        setupLabels()
    }
    
    private func setupSubscriptions() {
        setupMovieItemSubscription()
        setupImageSubscription()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.easy.layout(
            Top(0).to(view.safeAreaLayoutGuide, .top),
            Bottom(0).to(view.safeAreaLayoutGuide, .bottom),
            Leading(0).to(view.safeAreaLayoutGuide, .leading),
            Trailing(0).to(view.safeAreaLayoutGuide, .trailing)
        )
        
        scrollView.addSubview(contentView)
        contentView.easy.layout(
            Top().to(scrollView),
            Leading().to(scrollView),
            Trailing().to(scrollView),
            Bottom().to(scrollView).with(.custom(250)),
            CenterX(),
            CenterY().with(.custom(250))
        )
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        imageView.easy.layout(
            Top(20).to(contentView, .top),
            CenterX(),
            Width(240),
            Height(300)
        )
    }
    
    private func setupTitle() {
        titleLabel.textAlignment = .center
        
        titleLabel.easy.layout(
            Top(15).to(imageView, .bottom),
            Leading(20).to(contentView),
            Trailing(20).to(contentView)
        )
    }
    
    private func setupTitleLabels() {
        let titles = ["Overview", "Popularity", "Release Date", "Vote Average", "Vote Count"]
        [overviewTitleLabel, popularityTitleLabel, releaseDateTitleLabel, voteAverageTitleLabel, voteCountTitleLabel].enumerated().forEach { index, label in
            label.attributedText = String.create(titles[index], font: UIFont.systemFont(ofSize: 17))
        }
        
        overviewTitleLabel.easy.layout(
            Top(25).to(titleLabel, .bottom),
            Leading(20).to(contentView)
        )
        popularityTitleLabel.easy.layout(
            Top(5).to(overviewLabel, .bottom),
            Leading(20).to(contentView)
        )
        releaseDateTitleLabel.easy.layout(
            Top(5).to(overviewLabel, .bottom),
            Trailing(20).to(contentView)
        )
        voteAverageTitleLabel.easy.layout(
            Top(5).to(popularityLabel, .bottom),
            Leading(20).to(contentView)
        )
        voteCountTitleLabel.easy.layout(
            Top(5).to(releaseDateLabel, .bottom),
            Leading().to(releaseDateTitleLabel, .leading),
            Trailing(20).to(contentView)
        )
    }
    
    private func setupLabels() {
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byTruncatingTail

        
        overviewLabel.easy.layout(
            Top(3).to(overviewTitleLabel, .bottom),
            Leading(20).to(contentView),
            Trailing(20).to(contentView)
        )
        popularityLabel.easy.layout(
            Top(3).to(popularityTitleLabel, .bottom),
            Leading(20).to(contentView),
            Width().like(popularityTitleLabel)
        )
        releaseDateLabel.easy.layout(
            Top(3).to(releaseDateTitleLabel, .bottom),
            Leading().to(releaseDateTitleLabel, .leading),
            Width().like(releaseDateTitleLabel)
        )
        voteAverageLabel.easy.layout(
            Top(3).to(voteAverageTitleLabel, .bottom),
            Bottom(50).to(contentView),
            Leading(20).to(contentView),
            Width().like(voteAverageTitleLabel)
        )
        voteCountLabel.easy.layout(
            Top(3).to(voteCountTitleLabel, .bottom),
            Bottom(50).to(contentView),
            Leading().to(voteCountTitleLabel, .leading),
            Width().like(voteCountTitleLabel)
        )
    }
    
    private func setupMovieItemSubscription() {
        viewModel.movie
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.imageUrl = "\(Constants.photoBaseUrl)\(movie.poster_path)"
                self.titleLabel.attributedText = String.create(movie.original_title, font: UIFont.systemFont(ofSize: 19, weight: .bold))
                self.overviewLabel.attributedText = String.create(movie.overview, font: UIFont.systemFont(ofSize: 13, weight: .light))
                let popularity = "\(Int(movie.popularity.rounded(.toNearestOrAwayFromZero)))"
                self.popularityLabel.attributedText = String.create(popularity, font: UIFont.systemFont(ofSize: 13, weight: .light))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "y-MMM-dd"
                let releaseDate = dateFormatter.date(from: movie.release_date) ?? Date()
                dateFormatter.dateFormat = "dd/MMM/y"
                let releaseDateStringFormatted = dateFormatter.string(from: releaseDate)
                self.releaseDateLabel.attributedText = String.create(releaseDateStringFormatted, font: UIFont.systemFont(ofSize: 13, weight: .light))
                
                self.voteAverageLabel.attributedText = String.create("\(movie.vote_average)", font: UIFont.systemFont(ofSize: 13, weight: .light))
                self.voteCountLabel.attributedText = String.create("\(movie.vote_count)", font: UIFont.systemFont(ofSize: 13, weight: .light))
            })
            .disposed(by: disposeBag)
    }
    
    private func setupImageSubscription() {
        viewModel.getImage(url: self.imageUrl)
            .debug()
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
}

extension MovieDetailsViewController {
    enum Constants {
        static let photoBaseUrl = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/"
    }
}
