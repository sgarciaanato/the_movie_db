//
//  WatchListTableViewDelegate.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class WatchListTableViewDelegate: NSObject, UITableViewDelegate {
    weak var presenter: WatchListPresenter?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = WatchList.shared.movies[indexPath.row]
        presenter?.performAction(.openMovie(movie: selectedMovie))
    }
}
