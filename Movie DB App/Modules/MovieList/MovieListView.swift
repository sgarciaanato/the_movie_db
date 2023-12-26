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
    var searchText: String? { get set }
    func openWatchList()
}

final class MovieListView: UIView {
    weak var delegate: MovieListDelegate?
    
    lazy var loadingMore = false {
        didSet {
            loadingMoreIndicator.isHidden = !loadingMore
        }
    }
    
    private lazy var searchDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 27)
        label.text = "Find your movies"
        return label
    }()
    
    private lazy var searchBarTextField: TextField = {
        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "LightColor")
        if let textColor = UIColor(named: "TextColor") {
            textField.attributedPlaceholder = NSAttributedString(string:"Search Here ...", attributes:[NSAttributedString.Key.foregroundColor: textColor])
        }
        textField.textColor = UIColor(named: "TextColor")
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
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
    
    lazy var loadingMoreIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = UIColor(named: "TextColor")
        return activityIndicator
    }()
    
    lazy var openWatchListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Watch List", for: .normal)
        button.setImage(UIImage(named: "BookmarkNegative"), for: .normal)
        button.setTitleColor(UIColor(named: "BackgroundColor"), for: .normal)
        button.addTarget(self, action: #selector(openWatchList), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageEdgeInsets.right = 12
        button.backgroundColor = UIColor(named: "TintColor")
        button.layer.cornerRadius = 16
        // reverse image and title
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return button
    }()
    
    init(delegate: MovieListDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        configureSearchView()
        configureCategories()
        configureMovieList()
        configureWatchListButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList(notification:)), name: Notification.Name.watchListUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieListView {
    func configureSearchView() {
        configureSearchDescriptionLabel()
        configureSearchTextField()
    }
    
    func configureSearchDescriptionLabel() {
        addSubview(searchDescriptionLabel)
        
        NSLayoutConstraint.activate([
            searchDescriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            searchDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            searchDescriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureSearchTextField() {
        addSubview(searchBarTextField)
        
        NSLayoutConstraint.activate([
            searchBarTextField.topAnchor.constraint(equalTo: searchDescriptionLabel.bottomAnchor, constant: 18),
            searchBarTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            searchBarTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -29),
            searchBarTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func configureCategoriesTitle() {
        addSubview(categoriesTitleLabel)
        
        NSLayoutConstraint.activate([
            categoriesTitleLabel.topAnchor.constraint(equalTo: searchBarTextField.bottomAnchor, constant: 18),
            categoriesTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            categoriesTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
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
    
    func configureMovieList() {
        movieListTableView.delegate = delegate?.tableViewDelegate
        movieListTableView.dataSource = delegate?.tableViewDataSource
        movieListTableView.backgroundColor = .clear
        
        addSubview(movieListTableView)
        
        NSLayoutConstraint.activate([
            movieListTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 18),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            movieListTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            movieListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
        movieListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 21, right: 0)
        
        
        addSubview(loadingMoreIndicator)
        DispatchQueue.main.asyncIfRequired { [weak self] in
            guard let self else { return }
            loadingMoreIndicator.startAnimating()
        }
        NSLayoutConstraint.activate([
            loadingMoreIndicator.centerXAnchor.constraint(equalTo: movieListTableView.centerXAnchor),
            loadingMoreIndicator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureWatchListButton() {
        addSubview(openWatchListButton)
        
        NSLayoutConstraint.activate([
            openWatchListButton.heightAnchor.constraint(equalToConstant: 42),
            openWatchListButton.widthAnchor.constraint(equalToConstant: 134),
            openWatchListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -29),
            openWatchListButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -31)
        ])
    }
    
    @objc func openWatchList() {
        delegate?.openWatchList()
    }
    
    @objc func reloadList(notification: Notification) {
        movieListTableView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.searchText = textField.text
    }
}

extension MovieListView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBarTextField.endEditing(true)
        return false
    }
}

fileprivate class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
