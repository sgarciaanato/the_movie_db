//
//  MovieListTableViewDataSource.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieListTableViewDataSource: NSObject, UITableViewDataSource {
    var movies: [Movie] = []
    weak var presenter: MovieListPresenter?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = MovieTableViewCell(movie: movie)
        presenter?.getImageFrom(movie.posterPath, imageView: cell.movieImageView)
        return cell
    }
}
