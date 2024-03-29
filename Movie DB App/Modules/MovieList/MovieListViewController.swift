//
//  MovieListViewController.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieListViewController: UIViewController {
    var presenter: MovieListPresenter?
    var movieListView: MovieListView?
    
    init(presenter: MovieListPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        title = "Movie DB App"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        movieListView = MovieListView(delegate: self)
        view = movieListView
    }
}

extension MovieListViewController: MovieListDelegate {
    var searchText: String? {
        get {
            presenter?.searchText
        }
        set {
            presenter?.searchText = newValue
        }
    }
    
    var tableViewDelegate: UITableViewDelegate? { presenter?.tableViewDelegate }
    
    var tableViewDataSource: UITableViewDataSource? { presenter?.tableViewDataSource }
    
    var categoriesCollectionViewDelegate: UICollectionViewDelegate? { presenter?.categoriesCollectionViewDelegate }
    
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { presenter?.categoriesCollectionViewDataSource }
    
    func openWatchList() {
        presenter?.performAction(.openWatchList)
    }
}
