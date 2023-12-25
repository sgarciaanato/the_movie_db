//
//  Genre.swift
//  Movie DB App
//
//  Created by Trece on 23-12-23.
//

struct Genre: Codable, Equatable {
    let id: Int?
    let endpoint: String?
    let name: String?
    
    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        if lhs.id == nil && lhs.endpoint == nil && rhs.name == nil {
            return false
        }
        if rhs.id == nil && rhs.endpoint == nil && rhs.name == nil {
            return false
        }
        return lhs.id == rhs.id && lhs.endpoint == rhs.endpoint && lhs.name == rhs.name
    }
}
