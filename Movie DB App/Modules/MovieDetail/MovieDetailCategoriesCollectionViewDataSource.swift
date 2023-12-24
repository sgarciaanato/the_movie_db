//
//  MovieDetailCategoriesCollectionViewDataSource.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import UIKit

final class MovieDetailCategoriesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var presenter: MovieDetailPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let genre = presenter?.genres?[indexPath.row], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellView", for: indexPath) as? CategoryCellView else { return UICollectionViewCell() }
        cell.configure(with: genre, selected: nil)
        return cell
    }
}
