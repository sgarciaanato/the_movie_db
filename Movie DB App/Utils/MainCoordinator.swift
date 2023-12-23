//
//  MainCoordinator.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init() {
        self.navigationController = UINavigationController()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "WhiteColor") ?? .white]
    }
    
    func performAction(_ action: Action) {
        switch action {
        case .openMovie:
            let presenter: Presenter & Coordinating = DefaultMovieDetailPresenter(coordinator: self)
            navigationController?.pushViewController(presenter.viewController, animated: true)
        }
    }
    
    func start() {
        let presenter: Presenter & Coordinating = DefaultMovieListPresenter(coordinator: self)
        navigationController?.viewControllers = [presenter.viewController]
    }
}
