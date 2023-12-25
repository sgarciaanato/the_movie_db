//
//  MovieTests.swift
//  Movie DB AppTests
//
//  Created by Samuel on 25-12-23.
//

import XCTest
@testable import Movie_DB_App

final class MovieTests: XCTestCase {
    func testInit() {
        let movie: Movie = Utils.shared.modelFrom("Movie_Mock")
        XCTAssertEqual(movie.adult, false)
        XCTAssertEqual(movie.backdropPath, "/5a4JdoFwll5DRtKMe7JLuGQ9yJm.jpg")
        XCTAssertEqual(movie.genreIds!.count, 3)
        XCTAssertEqual(movie.id, 695721)
        XCTAssertEqual(movie.originalLanguage, "en")
        XCTAssertEqual(movie.originalTitle, "The Hunger Games: The Ballad of Songbirds & Snakes")
        XCTAssertEqual(movie.overview, "64 years before he becomes the tyrannical president of Panem, Coriolanus Snow sees a chance for a change in fortunes when he mentors Lucy Gray Baird, the female tribute from District 12.")
        XCTAssertEqual(movie.popularity, 2786.228)
        XCTAssertEqual(movie.posterPath, "/mBaXZ95R2OxueZhvQbcEWy2DqyO.jpg")
        XCTAssertEqual(movie.releaseDate, "2023-11-15")
        XCTAssertEqual(movie.title, "The Hunger Games: The Ballad of Songbirds & Snakes")
        XCTAssertEqual(movie.video, false)
        XCTAssertEqual(movie.voteAverage, 7.217)
        XCTAssertEqual(movie.voteCount, 973)
    }
}
