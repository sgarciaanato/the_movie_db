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
    
    func getGenres(completionHandler: @escaping (Result<GenreList, MovieListNetworkError>) -> Void) {
        self.performGet(withEndpoint: Endpoint.genreList.rawValue, parameters: [:]) { data, error in
            do {
                let genres = try JSONDecoder().decode(GenreList.self, from: data)
                completionHandler(.success(genres))
            } catch {
                debugPrint(error)
                completionHandler(.failure(.errorDecoding))
            }
        }
    }
}
