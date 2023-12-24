//
//  MovieDetailNetworkManager.swift
//  Movie DB App
//
//  Created by Samuel on 23-12-23.
//

import Foundation

enum MovieDetailNetworkError: Error {
    case noData
}

final class MovieDetailNetworkManager: NetworkManager {
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
            completionHandler(.failure(MovieDetailNetworkError.noData as Error))
        }
    }
}
