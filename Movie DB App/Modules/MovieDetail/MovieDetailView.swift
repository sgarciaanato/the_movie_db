//
//  MovieDetailView.swift
//  Movie DB App
//
//  Created by Samuel on 23-12-23.
//

import UIKit

protocol MoveDetailDelegate: NSObject {
    
}

final class MovieDetailView: UIView {
    weak var delegate: MoveDetailDelegate?
    
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
    
    init(delegate: MoveDetailDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = UIColor(named: "BackgroundColor")
        configureBackdropImageView()
        configurePosterImageView()
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
}
