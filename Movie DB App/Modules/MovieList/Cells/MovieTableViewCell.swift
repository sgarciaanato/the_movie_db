//
//  MovieTableViewCell.swift
//  Movie DB App
//
//  Created by Trece on 23-12-23.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    var movie: Movie
    
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.text = "Title:"
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.text = "Release Date:"
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private lazy var movieReleaseDateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private lazy var averageRatingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.text = "Average Rating:"
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    private lazy var movieAverageRatingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(style: .default, reuseIdentifier: "MovieTableViewCell")
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieTableViewCell {
    func configureViews() {
        backgroundColor = .clear
        contentView.heightAnchor.constraint(equalToConstant: 138).isActive = true
        configureImageView()
        configureTitleLabel()
        configureReleaseDateLabel()
        configureAverageRatingLabel()
    }
    
    func configureImageView() {
        contentView.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 29),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            movieImageView.heightAnchor.constraint(equalToConstant: 120),
            movieImageView.widthAnchor.constraint(equalToConstant: 95),
        ])
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(movieTitleLabel)
        
        movieTitleLabel.text = movie.title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureReleaseDateLabel() {
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(movieReleaseDateLabel)
        
        movieReleaseDateLabel.text = movie.releaseDate
        
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 5),
            releaseDateLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureAverageRatingLabel() {
        guard let voteAverage = movie.voteAverage else { return }
        contentView.addSubview(averageRatingLabel)
        contentView.addSubview(movieAverageRatingLabel)
        
        movieAverageRatingLabel.text = String(format: "%.1f", voteAverage)
        
        NSLayoutConstraint.activate([
            averageRatingLabel.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: 5),
            averageRatingLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            averageRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieAverageRatingLabel.topAnchor.constraint(equalTo: averageRatingLabel.bottomAnchor),
            movieAverageRatingLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 22),
            movieAverageRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
