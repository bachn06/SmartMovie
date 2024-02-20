//
//  MovieDisplayModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 06/04/2023.
//

import Foundation

struct MovieDisplayModel {
    let id: Int
    let title: String
    let overview: String
    let genres: [GenreResponseEntity]
    let vote: Double
    let posterPath: String
    let backdropPath: String
    let language: String
    let releaseDate: String
    let duration: String
    let voteAverage: Double

    init() {
        self.id = 0
        self.title = ""
        self.overview = ""
        self.genres = []
        self.vote = 0.0
        self.posterPath = ""
        self.backdropPath = ""
        self.language = ""
        self.releaseDate = ""
        self.duration = ""
        self.voteAverage = 0.0
    }

    init(response: MovieResponseEntity) {
        self.id = response.id ?? 0
        self.title = response.title ?? response.originalTitle ?? ""
        self.overview = response.overview ?? ""
        self.posterPath = response.posterPath ?? ""
        self.backdropPath = response.backdropPath ?? posterPath
        self.genres = response.genres ?? []
        self.vote = response.voteAverage ?? 0.0
        self.language = response.originalLanguage ?? ""
        self.releaseDate = response.releaseDate ?? ""
        self.duration = timeMovie(response.runtime ?? 0)
        self.voteAverage = response.voteAverage ?? 0.0
    }
}
