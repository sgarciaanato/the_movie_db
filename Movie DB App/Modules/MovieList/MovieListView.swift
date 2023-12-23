//
//  MovieListView.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

protocol MovieListDelegate: AnyObject {
    var tableViewDelegate: UITableViewDelegate? { get }
    var tableViewDataSource: UITableViewDataSource? { get }
    var categoriesCollectionViewDelegate: UICollectionViewDelegate? { get }
    var categoriesCollectionViewDataSource: UICollectionViewDataSource? { get }
    func didSelectMovie(_ movieID: Int)
}

final class MovieListView: UIView {
    weak var delegate: MovieListDelegate?
    
    private lazy var searchDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 27)
        label.text = "Find your movies"
        return label
    }()
    
    private lazy var categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 27)
        label.text = "Categories"
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
        return collectionView
    }()
    
    lazy var movieListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    init(delegate: MovieListDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        configureSearchView()
        configureCategories()
        configureMovieList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieListView {
    func configureSearchView() {
        configureSearchDescriptionLabel()
    }
    
    func configureSearchDescriptionLabel() {
        addSubview(searchDescriptionLabel)
        
        NSLayoutConstraint.activate([
            searchDescriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            searchDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            searchDescriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureCategories() {
        configureCategoriesTitle()
        categoriesCollectionView.delegate = delegate?.categoriesCollectionViewDelegate
        categoriesCollectionView.dataSource = delegate?.categoriesCollectionViewDataSource
        addSubview(categoriesCollectionView)
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: categoriesTitleLabel.bottomAnchor, constant: 18),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configureCategoriesTitle() {
        addSubview(categoriesTitleLabel)
        
        NSLayoutConstraint.activate([
            categoriesTitleLabel.topAnchor.constraint(equalTo: searchDescriptionLabel.bottomAnchor, constant: 18),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            categoriesTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureMovieList() {
        movieListTableView.delegate = delegate?.tableViewDelegate
        movieListTableView.dataSource = delegate?.tableViewDataSource
        movieListTableView.backgroundColor = .clear
        
        addSubview(movieListTableView)
        
        NSLayoutConstraint.activate([
            movieListTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 18),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            movieListTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            movieListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor ),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}
