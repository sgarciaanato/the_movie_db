//
//  AuthorDetailTests.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import XCTest
@testable import Movie_DB_App

final class AuthorDetailTests: XCTestCase {

    func testInit() {
        let authorDetail: AuthorDetail = Utils.shared.modelFrom("AuthorDetail_Mock")
        XCTAssertEqual(authorDetail.name, "CinemaSerf")
        XCTAssertEqual(authorDetail.username, "Geronimo1967")
        XCTAssertEqual(authorDetail.avatarPath, "/1kks3YnVkpyQxzw36CObFPvhL5f.jpg")
        XCTAssertEqual(authorDetail.rating, 7)
    }
}
