//
//  MovieListNetworkManager.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import Foundation

enum NetworkError: Error {
    case errorDecoding
    case noData
}

final class MovieListNetworkManager: NetworkManager {
    func getMovies(genre: Genre, completionHandler: @escaping (Result<MovieList, NetworkError>) -> Void) {
        guard let endpoint = genre.endpoint else { return }
        self.performGet(withEndpoint: endpoint) { data, error in
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                completionHandler(.success(movies))
            } catch {
                completionHandler(.failure(.errorDecoding))
            }
        }
    }
    
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
            completionHandler(.failure(NetworkError.noData as Error))
        }
    }
}
