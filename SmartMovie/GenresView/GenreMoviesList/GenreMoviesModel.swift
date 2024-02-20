//
//  GenreMoviesModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//
//

import Foundation

struct GenreMoviesViewEntity {
}

final class GenreMoviesModel {
    private let listGenreMoviesAPI: GetGenreMovieAPIProtocol = GetGenreMovieAPI()
    private let detailMovieAPI: GetDetailMovieAPIProtocol = GetDetailMovieAPI()
}

extension GenreMoviesModel: GenreMoviesModelProtocol {
    func getGenreMovies(genreId: Int, page: Int, result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listGenreMoviesAPI.getMoviesByGenre(genreId: genreId, page: page) { responseResult in
            switch responseResult {
            case .success(let data):
                result(.success(data.results))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void) {
        detailMovieAPI.getDetailMovie(movieId: movieId, completion: completion)
    }
}
