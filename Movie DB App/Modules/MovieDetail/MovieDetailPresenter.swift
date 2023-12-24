//
//  MovieDetailPresenter.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

protocol MovieDetailPresenter: AnyObject {
    var selectedMovie: Movie { get }
    func viewDidLoad()
}

final class DefaultMovieDetailPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var networkManager: MovieDetailNetworkManager?
    var _selectedMovie: Movie
    
    var _viewController: MovieDetailViewController?
    var viewController: UIViewController {
        if let _viewController {
            return _viewController
        }
        let vc = MovieDetailViewController(presenter: self)
        _viewController = vc
        return vc
    }
    
    init(coordinator: Coordinator? = nil, movie: Movie) {
        self.coordinator = coordinator
        self.networkManager = MovieDetailNetworkManager()
        self._selectedMovie = movie
    }
}

private extension DefaultMovieDetailPresenter {
    func configureBackdropImage() {
        guard let path = _selectedMovie.backdropPath, let imageView = _viewController?.movieDetailView?.backdropImageView else { return }
        getImageFrom(path, imageView: imageView)
    }
    
    func configurePosterImage() {
        guard let path = _selectedMovie.posterPath, let imageView = _viewController?.movieDetailView?.posterImageView else { return }
        getImageFrom(path, imageView: imageView)
    }
    
    func getImageFrom(_ path: String, imageView: UIImageView) {
        let indicator = addIndicatorToView(imageView)
        networkManager?.getDataFrom(path, completionHandler: { [weak self] result in
            if let self {
                self.removeIndicator(indicator)
            }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.asyncIfRequired {
                    imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error data -> \(error.localizedDescription)")
            }
        })
    }
    
    private func addIndicatorToView(_ view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = UIColor(named: "TextColor")
        view.addSubview(activityIndicator)
        DispatchQueue.main.asyncIfRequired {
            activityIndicator.startAnimating()
        }
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return activityIndicator
    }
    
    private func removeIndicator(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.asyncIfRequired {
            indicator.stopAnimating()
            indicator.superview?.alpha = 1
            indicator.removeFromSuperview()
        }
    }
}

extension DefaultMovieDetailPresenter: MovieDetailPresenter {
    var selectedMovie: Movie { _selectedMovie }
    
    func viewDidLoad() {
        configureBackdropImage()
        configurePosterImage()
    }
}
