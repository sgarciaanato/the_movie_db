//
//  WatchList.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import Foundation

extension Notification.Name {
    static let watchListUpdated = Notification.Name("WatchListUpdated")
}

final class WatchList {
    static let shared = WatchList()
    
    var movies: [Movie] {
        get {
            if let objects = UserDefaults.standard.value(forKey: "WatchList") as? Data {
                let decoder = JSONDecoder()
                if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Movie] {
                    return objectsDecoded
                }
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue){
                userDefaults.setValue(encoded, forKey: "WatchList")
                NotificationCenter.default.post(name: Notification.Name.watchListUpdated, object: nil)
            }
        }
    }
    
    private var userDefaults: UserDefaults
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    func addMovie(movie: Movie?) {
        guard let movie else { return }
        movies.append(movie)
    }
    
    func removeMovie(movie: Movie?) {
        guard let movie else { return }
        movies.removeAll { $0.id == movie.id }
    }
}
