//
//  WatchListNetworkManager.swift
//  Movie DB App
//
//  Created by Samuel on 24-12-23.
//

import Foundation

enum WatchListNetworkError: Error {
    case errorDecoding
    case noData
}

final class WatchListNetworkManager: NetworkManager {
    func getDataFrom(_ path: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        self.performGetResource(withEndpoint: path) { data, error in
            if let error {
                completionHandler(.failure(error))
                return
            }
            if let data {
                completionHandler(.success(data))
                return
            }
            completionHandler(.failure(MovieListNetworkError.noData as Error))
        }
    }
}
