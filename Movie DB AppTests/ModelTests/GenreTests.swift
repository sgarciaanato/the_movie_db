//
//  GenreTests.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import XCTest
@testable import Movie_DB_App

final class GenreTests: XCTestCase {
    func testInit() {
        let genre: Genre = Utils.shared.modelFrom("Genre_Mock")
        XCTAssertEqual(genre.id, 28)
        XCTAssertEqual(genre.endpoint, nil)
        XCTAssertEqual(genre.name, "Action")
    }
}
