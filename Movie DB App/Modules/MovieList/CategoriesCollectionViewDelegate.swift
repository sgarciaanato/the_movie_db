//
//  CategoriesCollectionViewDelegate.swift
//  Movie DB App
//
//  Created by Trece on 23-12-23.
//

import UIKit

final class CategoriesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    weak var presenter: MovieListPresenter?
    var selectedIndexPath: IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let genre = presenter?.genres[indexPath.row], genre != presenter?.selectedGenre else { return }
        presenter?.selectedGenre = genre
        collectionView.reloadItems(at: [selectedIndexPath ?? IndexPath(row: 0, section: 0), indexPath])
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}
