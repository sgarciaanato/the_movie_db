//
//  WatchListTableViewDataSource.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class WatchListTableViewDataSource: NSObject, UITableViewDataSource {
    weak var presenter: WatchListPresenter?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WatchList.shared.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movies = WatchList.shared.movies
        let movie = movies[indexPath.row]
        let cell = MovieTableViewCell(movie: movie)
        presenter?.getImageFrom(movie.posterPath, imageView: cell.movieImageView)
        return cell
    }
}
