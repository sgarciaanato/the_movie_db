//
//  MovieList.swift
//  Movie DB App
//
//  Created by Trece on 22-12-23.
//

import Foundation

struct MovieList: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
