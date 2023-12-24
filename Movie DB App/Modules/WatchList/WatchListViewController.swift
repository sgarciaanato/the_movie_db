//
//  WatchListViewController.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class WatchListViewController: UIViewController {
    var presenter: WatchListPresenter?
    var watchListView: WatchListView?
    
    init(presenter: WatchListPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        title = "Movie DB App"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        watchListView = WatchListView(delegate: self)
        view = watchListView
    }
}

extension WatchListViewController: WatchListDelegate {
    var tableViewDelegate: UITableViewDelegate? { presenter?.tableViewDelegate }
    
    var tableViewDataSource: UITableViewDataSource? { presenter?.tableViewDataSource }
    
    func goBack() {
        presenter?.performAction(.goBack)
    }
    
    func selectMovie() {
        debugPrint("go")
    }
}
