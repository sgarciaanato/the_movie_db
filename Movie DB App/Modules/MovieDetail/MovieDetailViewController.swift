//
//  MovieDetailViewController.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    var presenter: MovieDetailPresenter?
    var movieDetailView: MovieDetailView?
    
    init(presenter: MovieDetailPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        movieDetailView = MovieDetailView(delegate: self)
        view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailDelegate {
    var selectedMovie: Movie? { presenter?.selectedMovie }
    
    func goBack() {
        presenter?.goBack()
    }
}
