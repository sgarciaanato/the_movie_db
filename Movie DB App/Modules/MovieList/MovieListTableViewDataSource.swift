//
//  MovieListTableViewDataSource.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieListTableViewDataSource: NSObject, UITableViewDataSource {
    weak var presenter: MovieListPresenter?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movies = presenter?.movies else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        let cell = MovieTableViewCell(movie: movie)
        presenter?.getImageFrom(movie.posterPath, imageView: cell.movieImageView)
        if indexPath.row >= movies.count - 5 {
            presenter?.loadMore()
        }
        return cell
    }
}
