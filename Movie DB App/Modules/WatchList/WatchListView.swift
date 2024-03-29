//
//  WatchListView.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

protocol WatchListDelegate: NSObject {
    var tableViewDelegate: UITableViewDelegate? { get }
    var tableViewDataSource: UITableViewDataSource? { get }
    func goBack()
    func selectMovie()
}

final class WatchListView: UIView {
    weak var delegate: WatchListDelegate?
    
    lazy var yourWatchlistTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 27)
        label.text = "Your Watch List"
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    lazy var movieListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = WatchList.shared.movies.isEmpty
        return tableView
    }()
    
    lazy var noMoviesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.text = "No items on your Watch List"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.isHidden = !WatchList.shared.movies.isEmpty
        label.numberOfLines = 0
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        let backArrowImage = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate)
        button.setImage(backArrowImage, for: .normal)
        button.tintColor = UIColor(named: "TextColor")
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageEdgeInsets.right = 12
        button.backgroundColor = UIColor(named: "LightColor")
        button.layer.cornerRadius = 16
        return button
    }()
    
    init(delegate: WatchListDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = UIColor(named: "BackgroundColor")
        configureWatchListTitleLabel()
        configureMovieList()
        configureNoMoviesLabel()
        configureBackButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadList(notification:)), name: Notification.Name.watchListUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WatchListView {
    
    func configureWatchListTitleLabel() {
        addSubview(yourWatchlistTitleLabel)
        
        NSLayoutConstraint.activate([
            yourWatchlistTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            yourWatchlistTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 29),
            yourWatchlistTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureMovieList() {
        movieListTableView.delegate = delegate?.tableViewDelegate
        movieListTableView.dataSource = delegate?.tableViewDataSource
        movieListTableView.backgroundColor = .clear
        
        addSubview(movieListTableView)
        
        NSLayoutConstraint.activate([
            movieListTableView.topAnchor.constraint(equalTo: yourWatchlistTitleLabel.bottomAnchor, constant: 18),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            movieListTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            movieListTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
        movieListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 21, right: 0)
    }
    
    func configureNoMoviesLabel() {
        addSubview(noMoviesLabel)
        
        NSLayoutConstraint.activate([
            noMoviesLabel.topAnchor.constraint(equalTo: yourWatchlistTitleLabel.bottomAnchor, constant: 18),
            noMoviesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noMoviesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            noMoviesLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureBackButton() {
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 12),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.widthAnchor.constraint(equalToConstant: 102)
        ])
    }
    
    @objc func goBack() {
        delegate?.goBack()
    }
    
    @objc func reloadList(notification: Notification) {
        DispatchQueue.main.asyncIfRequired { [weak self] in
            guard let self else { return }
            self.movieListTableView.isHidden = WatchList.shared.movies.isEmpty
            self.noMoviesLabel.isHidden = !WatchList.shared.movies.isEmpty
            self.movieListTableView.reloadData()
        }
    }
}
