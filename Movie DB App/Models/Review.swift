//
//  Review.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

struct Review: Decodable {
    let author: String?
    let authorDetails: AuthorDetail?
    let content: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case id
    }
}
