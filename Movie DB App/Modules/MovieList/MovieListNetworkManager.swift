//
//  MovieListNetworkManager.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import Foundation

enum MovieListNetworkError: Error {
    case errorDecoding
    case noData
}

enum Endpoint: String {
    case movieDetail = "/3/movie/%i"
    case movieReviews = "/3/movie/%i/reviews"
    case genreList = "/3/genre/movie/list"
    case discoverGenre = "/3/discover/movie"
}

final class MovieListNetworkManager: NetworkManager {
    let genreListEndpoint = "/3/genre/movie/list"
    
    func getMovies(genre: Genre, page: Int? = nil, completionHandler: @escaping (Result<MovieList, MovieListNetworkError>) -> Void) {
        let endpoint = genre.endpoint ?? Endpoint.discoverGenre.rawValue
        var params: [String: String] = [:]
        if let genreId = genre.id {
            params["with_genres"] = "\(genreId)"
        }
        if let page {
            params["page"] = "\(page)"
        }
        self.performGet(withEndpoint: endpoint, parameters: params) { data, error in
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                completionHandler(.success(movies))
            } catch {
                debugPrint(error)
                completionHandler(.failure(.errorDecoding))
            }
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
