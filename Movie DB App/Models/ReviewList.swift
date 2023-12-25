//
//  ReviewList.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

struct ReviewList: Decodable {
    let page: Int
    var results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
