//
//  AuthorDetail.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

struct AuthorDetail: Decodable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: CGFloat?
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
