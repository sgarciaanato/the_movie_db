//
//  WatchListPresenter.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

protocol WatchListPresenter: AnyObject {
    var tableViewDelegate: UITableViewDelegate? { get }
    var tableViewDataSource: UITableViewDataSource? { get }
    func performAction(_ action: Action)
    func getImageFrom(_ path: String?, imageView: UIImageView)
}

final class DefaultWatchListPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var networkManager: MovieListNetworkManager?
    var _tableViewDelegate: WatchListTableViewDelegate?
    var _tableViewDataSource: WatchListTableViewDataSource?
    
    var _viewController: WatchListViewController?
    var viewController: UIViewController {
        if let _viewController {
            return _viewController
        }
        let vc = WatchListViewController(presenter: self)
        _viewController = vc
        return vc
    }
    
    init(coordinator: Coordinator? = nil) {
        self.coordinator = coordinator
        self.networkManager = MovieListNetworkManager()
        self._tableViewDelegate = WatchListTableViewDelegate()
        self._tableViewDataSource = WatchListTableViewDataSource()
        self._tableViewDelegate?.presenter = self
        self._tableViewDataSource?.presenter = self
    }
}
extension DefaultWatchListPresenter: WatchListPresenter {
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
    
    var tableViewDelegate: UITableViewDelegate? { _tableViewDelegate }
    
    var tableViewDataSource: UITableViewDataSource? { _tableViewDataSource }
    
    func performAction(_ action: Action) {
        coordinator?.performAction(action)
    }
}

private extension DefaultWatchListPresenter {
    
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
