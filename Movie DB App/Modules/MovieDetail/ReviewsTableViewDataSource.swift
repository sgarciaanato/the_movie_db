//
//  ReviewsTableViewDataSource.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

import UIKit

final class ReviewsTableViewDataSource: NSObject, UITableViewDataSource {
    weak var presenter: MovieDetailPresenter?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviews = presenter?.reviews else { return UITableViewCell() }
        let review = reviews[indexPath.row]
        let cell = ReviewTableViewCell(review: review)
        presenter?.getImageFrom(review.authorDetails?.avatarPath, imageView: cell.avatarImageView)
        return cell
    }
}
