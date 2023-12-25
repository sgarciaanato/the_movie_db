//
//  ReviewsView.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class ReviewsView: UIView {
    weak var delegate: MovieDetailDelegate?
    
    lazy var reviewsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = delegate?.reviewsTableViewDataSource
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        return tableView
    }()
    
    init(delegate: MovieDetailDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ReviewsView {
    func configureTableView() {
        addSubview(reviewsTableView)
        
        NSLayoutConstraint.activate([
            reviewsTableView.topAnchor.constraint(equalTo: topAnchor),
            reviewsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reviewsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reviewsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
