//
//  MovieDetailViewController.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    var presenter: MovieDetailPresenter?
    
    init(presenter: MovieDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
