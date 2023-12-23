//
//  MovieDetailPresenter.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

protocol MovieDetailPresenter: AnyObject {
    
}

final class DefaultMovieDetailPresenter: Presenter, Coordinating {
    var coordinator: Coordinator?
    var _viewController: MovieDetailViewController?
    var viewController: UIViewController {
        if let _viewController {
            return _viewController
        }
        let vc = MovieDetailViewController(presenter: self)
        _viewController = vc
        return vc
    }
    
    init(coordinator: Coordinator? = nil) {
        self.coordinator = coordinator
    }
}

extension DefaultMovieDetailPresenter: MovieDetailPresenter {
    
}
