//
//  AboutMovieView.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class AboutMovieView: UIView {
    let movie: Movie?
    
    lazy var overviewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "Overviews:"
        return label
    }()
    
    lazy var movieOverviewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "Release Date:"
        return label
    }()
    
    lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var averageRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "Average Rating:"
        return label
    }()
    
    lazy var movieAverageRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var rateCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "Rate Count:"
        return label
    }()
    
    lazy var movieRateCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var popularityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "Popularity:"
        return label
    }()
    
    lazy var moviePopularityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    init(movie: Movie?) {
        self.movie = movie
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AboutMovieView {
    func configureViews() {
        configureOverviews()
        configureReleaseDate()
        configureAverageRating()
        configureRateCount()
        configurePopularity()
    }
    
    func configureOverviews() {
        addSubview(overviewsLabel)
        addSubview(movieOverviewsLabel)
        
        movieOverviewsLabel.text = movie?.overview
        
        NSLayoutConstraint.activate([
            overviewsLabel.topAnchor.constraint(equalTo: topAnchor),
            overviewsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieOverviewsLabel.topAnchor.constraint(equalTo: overviewsLabel.bottomAnchor),
            movieOverviewsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieOverviewsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configureReleaseDate() {
        addSubview(releaseDateLabel)
        addSubview(movieReleaseDateLabel)
        
        movieReleaseDateLabel.text = movie?.releaseDate
        
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: movieOverviewsLabel.bottomAnchor, constant: 12),
            releaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieReleaseDateLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configureAverageRating() {
        addSubview(averageRatingLabel)
        addSubview(movieAverageRatingLabel)
        
        movieAverageRatingLabel.text = String(format: "%.1f", movie?.voteAverage ?? 0.0)
        
        NSLayoutConstraint.activate([
            averageRatingLabel.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: 12),
            averageRatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            movieAverageRatingLabel.topAnchor.constraint(equalTo: averageRatingLabel.bottomAnchor),
            movieAverageRatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func configureRateCount() {
        addSubview(rateCountLabel)
        addSubview(movieRateCountLabel)
        
        movieRateCountLabel.text = String(format: "%i", movie?.voteCount ?? 0)
        
        NSLayoutConstraint.activate([
            rateCountLabel.topAnchor.constraint(equalTo: averageRatingLabel.topAnchor),
            rateCountLabel.leadingAnchor.constraint(equalTo: averageRatingLabel.trailingAnchor, constant: 8),
            rateCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            rateCountLabel.widthAnchor.constraint(equalTo: averageRatingLabel.widthAnchor),
            
            movieRateCountLabel.topAnchor.constraint(equalTo: movieAverageRatingLabel.topAnchor),
            movieRateCountLabel.leadingAnchor.constraint(equalTo: rateCountLabel.leadingAnchor),
            movieRateCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieRateCountLabel.widthAnchor.constraint(equalTo: rateCountLabel.widthAnchor)
        ])
    }
    
    func configurePopularity() {
        addSubview(popularityLabel)
        addSubview(moviePopularityLabel)
        
        moviePopularityLabel.text = String(format: "%.3f",  movie?.popularity ?? 0.0)
        
        NSLayoutConstraint.activate([
            popularityLabel.topAnchor.constraint(equalTo: movieAverageRatingLabel.bottomAnchor, constant: 12),
            popularityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            popularityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            moviePopularityLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor),
            moviePopularityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePopularityLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
