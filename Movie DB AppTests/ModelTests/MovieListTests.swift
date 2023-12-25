//
//  MovieListTests.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import XCTest
@testable import Movie_DB_App

final class MovieListTests: XCTestCase {
    func testInit() {
        let movieList: MovieList = Utils.shared.modelFrom("MovieList_Mock")
        XCTAssertEqual(movieList.page, 1)
        XCTAssertEqual(movieList.results.count, 20)
        XCTAssertEqual(movieList.totalPages, 213)
    }
}
