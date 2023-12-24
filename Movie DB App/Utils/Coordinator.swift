//
//  Coordinator.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import UIKit

enum Action {
    case openMovie(movie: Movie)
}

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func performAction(_ action: Action)
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
