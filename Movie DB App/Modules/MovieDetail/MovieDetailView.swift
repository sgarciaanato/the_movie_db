//
//  MovieDetailView.swift
//  Movie DB App
//
//  Created by Samuel on 23-12-23.
//

import UIKit

protocol MovieDetailDelegate: NSObject {
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { get }
    var reviewsTableViewDataSource: UITableViewDataSource? { get }
    
    var selectedMovie: Movie? { get }
    func goBack()
}

final class MovieDetailView: UIView {
    weak var delegate: MovieDetailDelegate?
    var added: Bool {
        WatchList.shared.movies.contains { $0.id == delegate?.selectedMovie?.id }
    }
    
    lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 32)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCellView.self, forCellWithReuseIdentifier: "CategoryCellView")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 29, bottom: 0, right: 29)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    lazy var movieDescriptionView: MovieDescriptionView = {
        let movieDescriptionView = MovieDescriptionView(delegate: delegate)
        movieDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        return movieDescriptionView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        let backArrowImage = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate)
        button.setImage(backArrowImage, for: .normal)
        button.tintColor = UIColor(named: "TextColor")
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageEdgeInsets.right = 12
        button.backgroundColor = UIColor(named: "LightColor")
        button.layer.cornerRadius = 16
        return button
    }()
    
    lazy var watchListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleWatchList), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    init(delegate: MovieDetailDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = UIColor(named: "BackgroundColor")
        configureBackdropImageView()
        configurePosterImageView()
        configureTitleLabel()
        configureCategories()
        setUpMovieDescription()
        
        configureBackButton()
        configureWatchListButton()
        
        configureWatchListAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieDetailView {
    func configureBackdropImageView() {
        addSubview(backdropImageView)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 210),
        ])
    }
    
    func configurePosterImageView() {
        addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 95),
            
            posterImageView.centerYAnchor.constraint(equalTo: backdropImageView.bottomAnchor)
        ])
    }
    
    func configureTitleLabel() {
        addSubview(movieTitleLabel)
        
        movieTitleLabel.text = delegate?.selectedMovie?.title
        
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 12),
            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -29),
            movieTitleLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
        ])
    }
    
    func configureCategories() {
        categoriesCollectionView.dataSource = delegate?.categoriesCollectionViewDataSource
        addSubview(categoriesCollectionView)
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 18),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setUpMovieDescription() {
        addSubview(movieDescriptionView)
        
        NSLayoutConstraint.activate([
            movieDescriptionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 18),
            movieDescriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29),
            movieDescriptionView.trailingAnchor.constraint(equalTo: categoriesCollectionView.trailingAnchor, constant: -29)
        ])
    }
    
    func configureBackButton() {
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 12),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.widthAnchor.constraint(equalToConstant: 102),
            movieDescriptionView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -8)
        ])
    }
    
    func configureWatchListButton() {
        addSubview(watchListButton)
        
        NSLayoutConstraint.activate([
            watchListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            watchListButton.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            watchListButton.heightAnchor.constraint(equalToConstant: 42),
            watchListButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func configureWatchListAppearance() {
        let backArrowImage = added ? UIImage(named: "BookmarkCheckNegative") : UIImage(named: "Bookmark")
        watchListButton.setImage(backArrowImage, for: .normal)
        watchListButton.backgroundColor = added ? UIColor(named: "TintColor") : UIColor(named: "LightColor")
    }
    
    @objc func goBack() {
        delegate?.goBack()
    }
    
    @objc func toggleWatchList() {
        if added {
            WatchList.shared.removeMovie(movie: delegate?.selectedMovie)
        } else {
            WatchList.shared.addMovie(movie: delegate?.selectedMovie)
        }
        configureWatchListAppearance()
    }
}
