//
//  MovieList.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

class MovieList: Decodable {
    let page: Int
    var results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    func addMovie(movie: Movie) {
        results.append(movie)
    }
}
