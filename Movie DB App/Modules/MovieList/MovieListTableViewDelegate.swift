//
//  MovieListTableViewDelegate.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

final class MovieListTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
}
