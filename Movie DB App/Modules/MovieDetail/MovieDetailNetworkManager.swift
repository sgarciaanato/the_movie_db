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
    
    func getMovieDetail(movieID: Int, completionHandler: @escaping (Result<Movie, MovieListNetworkError>) -> Void) {
        self.performGet(withEndpoint: String(format: Endpoint.movieDetail.rawValue, movieID), parameters: [:]) { data, error in
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completionHandler(.success(movie))
            } catch {
                debugPrint(error)
                completionHandler(.failure(.errorDecoding))
            }
        }
    }
    
    func getReviews(movieID: Int, completionHandler: @escaping (Result<ReviewList, MovieListNetworkError>) -> Void) {
        self.performGet(withEndpoint: String(format: Endpoint.movieReviews.rawValue, movieID), parameters: [:]) { data, error in
            do {
                let reviews = try JSONDecoder().decode(ReviewList.self, from: data)
                completionHandler(.success(reviews))
            } catch {
                debugPrint(error)
                completionHandler(.failure(.errorDecoding))
            }
        }
    }
}
