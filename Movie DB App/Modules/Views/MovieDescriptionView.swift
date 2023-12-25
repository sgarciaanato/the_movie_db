//
//  MovieDescriptionView.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class MovieDescriptionView: UIView {
    weak var delegate: MovieDetailDelegate?
    
    lazy var aboutMovieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("About Movie", for: .normal)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.addTarget(self, action: #selector(scrollToAboutMovie), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reviews", for: .normal)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.addTarget(self, action: #selector(scrollToReviews), for: .touchUpInside)
        return button
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "LightColor")
        return view
    }()
    
    var indicatorViewleadingConstraint: NSLayoutConstraint?
    var contentOffset: CGFloat
    
    lazy var descriptionScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()
    
    lazy var aboutMovieView: AboutMovieView = {
        let view = AboutMovieView(movie: delegate?.selectedMovie)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var reviewsView: ReviewsView = {
        let view = ReviewsView(delegate: delegate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(delegate: MovieDetailDelegate?) {
        contentOffset = 0
        super.init(frame: .zero)
        self.delegate = delegate
        configureAboutMovieButton()
        configureReviewsButton()
        configureIndicatorView()
        configureDescriptionScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MovieDescriptionView {
    func configureAboutMovieButton() {
        addSubview(aboutMovieButton)
        
        NSLayoutConstraint.activate([
            aboutMovieButton.topAnchor.constraint(equalTo: topAnchor),
            aboutMovieButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            aboutMovieButton.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
    
    func configureReviewsButton() {
        addSubview(reviewsButton)
        
        NSLayoutConstraint.activate([
            reviewsButton.topAnchor.constraint(equalTo: topAnchor),
            reviewsButton.leadingAnchor.constraint(equalTo: aboutMovieButton.trailingAnchor, constant: 12),
            reviewsButton.heightAnchor.constraint(equalToConstant: 33),
            reviewsButton.widthAnchor.constraint(equalTo: aboutMovieButton.widthAnchor)
        ])
    }
    
    func configureIndicatorView() {
        addSubview(indicatorView)
        
        indicatorViewleadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: aboutMovieButton.leadingAnchor)
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: aboutMovieButton.bottomAnchor, constant: 7),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.widthAnchor.constraint(equalTo: aboutMovieButton.widthAnchor)
        ])
        
        guard let indicatorViewleadingConstraint else { return }
        indicatorViewleadingConstraint.isActive = true
    }
    
    func configureDescriptionScrollView() {
        addSubview(descriptionScrollView)
        
        NSLayoutConstraint.activate([
            descriptionScrollView.topAnchor.constraint(equalTo: aboutMovieButton.bottomAnchor, constant: 26),
            descriptionScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        configureAboutMovieView()
        configureReviewsView()
    }
    
    func configureAboutMovieView() {
        descriptionScrollView.addSubview(aboutMovieView)
        
        NSLayoutConstraint.activate([
            aboutMovieView.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor),
            aboutMovieView.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor),
            aboutMovieView.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor),
            aboutMovieView.heightAnchor.constraint(equalTo: descriptionScrollView.heightAnchor),
            aboutMovieView.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor)
        ])
    }
    
    func configureReviewsView() {
        descriptionScrollView.addSubview(reviewsView)
        
        NSLayoutConstraint.activate([
            reviewsView.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor),
            reviewsView.leadingAnchor.constraint(equalTo: aboutMovieView.trailingAnchor),
            reviewsView.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor),
            reviewsView.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor),
            reviewsView.heightAnchor.constraint(equalTo: descriptionScrollView.heightAnchor),
            reviewsView.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor)
        ])
    }
    
    @objc func scrollToReviews() {
        descriptionScrollView.setContentOffset(CGPoint(x: descriptionScrollView.frame.width, y:0), animated: true)
    }
    
    @objc func scrollToAboutMovie() {
        descriptionScrollView.setContentOffset(.zero, animated: true)
    }
    
    func fixScrollPosition(for scrollView: UIScrollView) {
        if (contentOffset > scrollView.contentOffset.x && scrollView.contentOffset.x < scrollView.frame.width) || scrollView.contentOffset.x <= 0 {
            scrollView.setContentOffset(.zero, animated: true)
            return
        }
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: true)
    }
}

extension MovieDescriptionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetPercentage = scrollView.contentOffset.x / scrollView.contentSize.width
        let totalWidth = aboutMovieButton.frame.width + reviewsButton.frame.width + 24
        indicatorViewleadingConstraint?.constant = totalWidth * offsetPercentage
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            contentOffset = scrollView.contentOffset.x
            scrollView.decelerationRate = .init(rawValue: 0.1)
            return
        }
        let offsetPercentage = scrollView.contentOffset.x / scrollView.contentSize.width
        scrollView.setContentOffset(offsetPercentage < 1/4 ? .zero : CGPoint(x: scrollView.frame.width, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fixScrollPosition(for: scrollView)
        scrollView.decelerationRate = .init(rawValue: 1)
    }
}
