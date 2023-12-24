//
//  MovieListTableViewDelegate.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieListTableViewDelegate: NSObject, UITableViewDelegate {
    weak var presenter: MovieListPresenter?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedMovie = presenter?.movieList?.results[indexPath.row] else { return }
        presenter?.performAction(.openMovie(movie: selectedMovie))
    }
}
