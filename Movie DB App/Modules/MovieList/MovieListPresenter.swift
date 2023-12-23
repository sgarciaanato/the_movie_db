//
//  MovieListPresenter.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

protocol MovieListPresenter: AnyObject {
    var tableViewDelegate: UITableViewDelegate? { get }
    var tableViewDataSource: UITableViewDataSource? { get }
    var categoriesCollectionViewDelegate: UICollectionViewDelegate? { get }
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { get }
    var genres: [Genre] { get }
    var selectedGenre: Genre? { get set }
    
    func performAction(_ action: Action)
    func getImageFrom(_ path: String?, imageView: UIImageView)
}

final class DefaultMovieListPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var networkManager: MovieListNetworkManager?
    var _tableViewDelegate: MovieListTableViewDelegate?
    var _tableViewDataSource: MovieListTableViewDataSource?
    var _categoriesCollectionViewDelegate: CategoriesCollectionViewDelegate?
    var _categoriesCollectionViewDataSource: CategoriesCollectionViewDataSource?
    var _genres: [Genre] = [
        Genre(id: nil, endpoint: "/3/movie/now_playing", name: "Now Playing"),
        Genre(id: nil, endpoint: "/3/movie/popular", name: "Popular"),
        Genre(id: nil, endpoint: "/3/movie/top_rated", name: "Top Rated"),
        Genre(id: nil, endpoint: "/3/movie/upcoming", name: "Upcoming"),
    ]
    var _selectedGenre: Genre? {
        didSet {
            getMovies(genre: _selectedGenre)
        }
    }
    
    weak var _viewController: MovieListViewController?
    var viewController: UIViewController {
        if let _viewController {
            return _viewController
        }
        let vc = MovieListViewController(presenter: self)
        _viewController = vc
        return vc
    }
    
    init(coordinator: Coordinator? = nil) {
        self.coordinator = coordinator
        self.networkManager = MovieListNetworkManager()
        self._tableViewDelegate = MovieListTableViewDelegate()
        self._tableViewDataSource = MovieListTableViewDataSource()
        self._tableViewDataSource?.presenter = self
        self._categoriesCollectionViewDelegate = CategoriesCollectionViewDelegate()
        self._categoriesCollectionViewDataSource = CategoriesCollectionViewDataSource()
        self._categoriesCollectionViewDataSource?.presenter = self
        self._categoriesCollectionViewDelegate?.presenter = self
        self._selectedGenre = genres.first
        getMovies(genre: self._selectedGenre)
    }
}

extension DefaultMovieListPresenter: MovieListPresenter {
    
    var tableViewDelegate: UITableViewDelegate? { _tableViewDelegate }
    
    var tableViewDataSource: UITableViewDataSource? { _tableViewDataSource }
    
    var categoriesCollectionViewDelegate: UICollectionViewDelegate? { _categoriesCollectionViewDelegate }
    
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { _categoriesCollectionViewDataSource }
    
    var genres: [Genre] { _genres }
    
    var selectedGenre: Genre? {
        get { _selectedGenre }
        set { _selectedGenre = newValue }
    }
    
    func performAction(_ action: Action) {
        coordinator?.performAction(action)
    }
    
    func getMovies(genre: Genre?) {
        guard let genre else { return }
        networkManager?.getMovies(genre: genre) { [weak self] result in
            guard let self, let vc = _viewController else { return }
            switch result {
            case .success(let movies):
                self._tableViewDataSource?.movies = movies.results
                DispatchQueue.main.asyncIfRequired {
                    vc.movieListView?.movieListTableView.reloadData()
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error -> \(error.localizedDescription)")
            }
        }
    }
    
    func getImageFrom(_ path: String?, imageView: UIImageView) {
        guard let path else { return }
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
}

private extension DefaultMovieListPresenter {
    
    private func addIndicatorToView(_ view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = UIColor(named: "WhiteColor")
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
