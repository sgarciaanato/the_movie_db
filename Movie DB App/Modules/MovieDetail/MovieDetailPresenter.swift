//
//  MovieDetailPresenter.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

protocol MovieDetailPresenter: AnyObject {
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { get }
    var reviewsTableViewDataSource: UITableViewDataSource? { get }
    var selectedMovie: Movie { get }
    var genres: [Genre] { get }
    var reviews: [Review] { get }
    func viewDidLoad()
    func goBack()
    func getImageFrom(_ path: String?, imageView: UIImageView)
}

final class DefaultMovieDetailPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var networkManager: MovieDetailNetworkManager?
    var _selectedMovie: Movie
    var _reviews: ReviewList?
    var _categoriesCollectionViewDataSource: MovieDetailCategoriesCollectionViewDataSource?
    var _reviewsTableViewDataSource: ReviewsTableViewDataSource?
    
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
        self._categoriesCollectionViewDataSource = MovieDetailCategoriesCollectionViewDataSource()
        self._categoriesCollectionViewDataSource?.presenter = self
        self._reviewsTableViewDataSource = ReviewsTableViewDataSource()
        self._reviewsTableViewDataSource?.presenter = self
        getMovieDetail()
        getReviews()
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
        let indicator = imageView.addIndicatorToView()
        networkManager?.getDataFrom(path, completionHandler: { result in
            indicator.removeIndicator()
            
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
    
    func getMovieDetail() {
        guard let movieID = selectedMovie.id else { return }
        networkManager?.getMovieDetail(movieID: movieID, completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self._selectedMovie = movie
                guard let vc = _viewController else { return }
                DispatchQueue.main.asyncIfRequired {
                    vc.movieDetailView?.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error data -> \(error.localizedDescription)")
            }
        })
    }
    
    func getReviews() {
        guard let movieID = selectedMovie.id else { return }
        networkManager?.getReviews(movieID: movieID, completionHandler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let reviews):
                self._reviews = reviews
                guard let vc = _viewController else { return }
                DispatchQueue.main.asyncIfRequired {
                    vc.movieDetailView?.movieDescriptionView.reviewsView.reviewsTableView.reloadData()
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error data -> \(error.localizedDescription)")
            }
        })
    }
}

extension DefaultMovieDetailPresenter: MovieDetailPresenter {
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { _categoriesCollectionViewDataSource }
    
    var reviewsTableViewDataSource: UITableViewDataSource? { _reviewsTableViewDataSource }
    
    var selectedMovie: Movie { _selectedMovie }
    
    var genres: [Genre] { selectedMovie.genres ?? [] }
    
    var reviews: [Review] { _reviews?.results ?? [] }
    
    func viewDidLoad() {
        configureBackdropImage()
        configurePosterImage()
    }
    
    func goBack() {
        coordinator?.performAction(.goBack)
    }
    
    func getImageFrom(_ path: String?, imageView: UIImageView) {
        guard let path else { return }
        let indicator = imageView.addIndicatorToView()
        networkManager?.getDataFrom(path, completionHandler: { result in
            indicator.removeIndicator()
            
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
}
