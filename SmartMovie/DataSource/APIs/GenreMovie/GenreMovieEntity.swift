//
//  GenreMovieEntity.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import Foundation

// MARK: - ListGenreMovieResponseEntity
struct ListGenreResponseEntity: Codable {
    let genres: [GenreResponseEntity]?
}

// MARK: - GenreMovieResponseEntity
struct GenreResponseEntity: Codable {
    let id: Int?
    let name: String?
}
