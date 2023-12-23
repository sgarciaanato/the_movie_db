//
//  CategoriesCollectionViewDataSource.swift
//  Movie DB App
//
//  Created by Trece on 23-12-23.
//

import UIKit

final class CategoriesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var presenter: MovieListPresenter?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.genres.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let genre = presenter?.genres[indexPath.row], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellView", for: indexPath) as? CategoryCellView else { return UICollectionViewCell() }
        cell.configure(with: genre, selected: presenter?.selectedGenre)
        return cell
    }
}
