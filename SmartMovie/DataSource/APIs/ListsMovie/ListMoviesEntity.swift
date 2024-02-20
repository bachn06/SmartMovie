//
//  ListMoviesEntity.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

// MARK: - ListMovieResponseEntity
struct ListMoviesResponseEntity: Codable {
    let page: Int?
    let results: [MovieResponseEntity]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MovieResponseEntity
struct MovieResponseEntity: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genres: [GenreResponseEntity]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime
    }
}
