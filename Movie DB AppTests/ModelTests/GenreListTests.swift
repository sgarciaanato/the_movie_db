//
//  GenreListTests.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import XCTest
@testable import Movie_DB_App

final class GenreListTests: XCTestCase {
    func testInit() {
        let genreList: GenreList = Utils.shared.modelFrom("GenreList_Mock")
        XCTAssertEqual(genreList.genres!.count, 19)
    }
}
