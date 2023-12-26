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
    var movies: [Movie] { get }
    var genres: [Genre] { get }
    var selectedGenre: Genre? { get set }
    var searchText: String? { get set }
    
    func viewDidLoad()
    func performAction(_ action: Action)
    func getImageFrom(_ path: String?, imageView: UIImageView)
    func loadMore()
}

final class DefaultMovieListPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var networkManager: MovieListNetworkManager?
    var _tableViewDelegate: MovieListTableViewDelegate?
    var _tableViewDataSource: MovieListTableViewDataSource?
    var _categoriesCollectionViewDelegate: CategoriesCollectionViewDelegate?
    var _categoriesCollectionViewDataSource: CategoriesCollectionViewDataSource?
    var _searchText: String?
    var loadingMore = false {
        didSet {
            guard let vc = _viewController else { return }
            vc.movieListView?.loadingMore = loadingMore
        }
    }
    var page: Int = 1
    
    var _movieList: MovieList?
    
    var _genres: [Genre] = [
        Genre(id: nil, endpoint: "/3/movie/now_playing", name: "Now Playing"),
        Genre(id: nil, endpoint: "/3/movie/popular", name: "Popular"),
        Genre(id: nil, endpoint: "/3/movie/top_rated", name: "Top Rated"),
        Genre(id: nil, endpoint: "/3/movie/upcoming", name: "Upcoming"),
    ]
    
    var _selectedGenre: Genre? {
        didSet {
            getMovieList(genre: _selectedGenre)
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
        self._tableViewDelegate?.presenter = self
        self._tableViewDataSource?.presenter = self
        self._categoriesCollectionViewDelegate = CategoriesCollectionViewDelegate()
        self._categoriesCollectionViewDataSource = CategoriesCollectionViewDataSource()
        self._categoriesCollectionViewDataSource?.presenter = self
        self._categoriesCollectionViewDelegate?.presenter = self
        self._selectedGenre = genres.first
    }
}

extension DefaultMovieListPresenter: MovieListPresenter {
    
    var searchText: String? {
        get {
            _searchText
        }
        set {
            _searchText = newValue
            guard let vc = _viewController else { return }
            DispatchQueue.main.asyncIfRequired {
                vc.movieListView?.movieListTableView.reloadData()
            }
        }
    }
    
    var tableViewDelegate: UITableViewDelegate? { _tableViewDelegate }
    
    var tableViewDataSource: UITableViewDataSource? { _tableViewDataSource }
    
    var categoriesCollectionViewDelegate: UICollectionViewDelegate? { _categoriesCollectionViewDelegate }
    
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { _categoriesCollectionViewDataSource }
    
    var movies: [Movie] {
        guard let movies = _movieList?.results else { return [] }
        
        if searchText == "" || searchText == nil {
            return movies
        }
        
        return movies.filter { movie in
            guard let searchText = searchText else { return false }
            return movie.title?.lowercased().range(of: searchText) != nil
        }
    }
    
    var genres: [Genre] { _genres }
    
    var selectedGenre: Genre? {
        get { _selectedGenre }
        set {
            page = 1
            _selectedGenre = newValue
            guard let vc = _viewController else { return }
            vc.movieListView?.movieListTableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func viewDidLoad() {
        getMovieList(genre: self._selectedGenre)
    }
    
    func performAction(_ action: Action) {
        coordinator?.performAction(action)
    }
    
    func getMovieList(genre: Genre?) {
        guard let genre, let tableView = _viewController?.movieListView?.movieListTableView else { return }
        let indicator = tableView.addIndicatorToView()
        networkManager?.getMovies(genre: genre) { [weak self] result in
            guard let self else { return }
            indicator.removeIndicator()
            switch result {
            case .success(let movieList):
                self._movieList = movieList
                DispatchQueue.main.asyncIfRequired {
                    tableView.reloadData()
                }
                return
            case .failure(let error):
                // TODO: Show error
                debugPrint("error -> \(error.localizedDescription)")
            }
        }
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
    
    func loadMore() {
        guard !loadingMore,
              let genre = _selectedGenre,
              page < _movieList?.totalPages ?? 0,
              let tableView = _viewController?.movieListView?.movieListTableView,
              let oldMovieList = self._movieList?.results else { return }
        loadingMore = true
        page += 1
        networkManager?.getMovies(genre: genre, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieList):
                var newMovieList = movieList.results
                newMovieList.removeAll { newMovie in
                    oldMovieList.contains(where: { oldMovie in
                        newMovie.id == oldMovie.id
                    })
                }
                guard let searchText, searchText != "" else {
                    DispatchQueue.main.asyncIfRequired {
                        tableView.beginUpdates()
                        for movie in newMovieList {
                            guard let position = self._movieList?.results.count else { continue }
                            self._movieList?.addMovie(movie: movie)
                            tableView.insertRows(at: [IndexPath(row: position, section: 0)], with: .fade)
                        }
                        tableView.endUpdates()
                        self.loadingMore = false
                    }
                    return
                }
                DispatchQueue.main.asyncIfRequired {
                    var isItemAdded = false
                    var filteredOldMovies = oldMovieList.filter { movie in
                        guard let searchText = self.searchText else { return false }
                        return movie.title?.lowercased().range(of: searchText) != nil
                    }
                    tableView.beginUpdates()
                    for movie in newMovieList {
                        self._movieList?.addMovie(movie: movie)
                        if movie.title?.lowercased().range(of: searchText) != nil {
                            let position = filteredOldMovies.count
                            filteredOldMovies.append(movie)
                            tableView.insertRows(at: [IndexPath(row: position, section: 0)], with: .fade)
                            isItemAdded = true
                        }
                    }
                    tableView.endUpdates()
                    if !isItemAdded {
                        self.loadingMore = false
                        self.loadMore()
                    }
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error -> \(error.localizedDescription)")
            }
            self.loadingMore = false
        }
    }
}

private extension DefaultMovieListPresenter {
    
    func getGenres() {
        networkManager?.getGenres() { [weak self] result in
            guard let self, let vc = _viewController else { return }
            switch result {
            case .success(let genreList):
                guard let genres = genreList.genres else { return }
                self._genres.append(contentsOf: genres)
                DispatchQueue.main.asyncIfRequired {
                    vc.movieListView?.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                // TODO: Show error
                debugPrint("error -> \(error.localizedDescription)")
            }
        }
    }
}
