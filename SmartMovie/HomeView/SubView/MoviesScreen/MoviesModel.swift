//
//  MoviesModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//
//

import Foundation

struct MoviesViewEntity {
}

final class MoviesModel {
    private let listMoviesAPI: GetListMoviesAPIProtocol = GetListMovieAPI()
    private let detailMovieAPI: GetDetailMovieAPIProtocol = GetDetailMovieAPI()
}

extension MoviesModel: MoviesModelProtocol {
    func getListMovie(endPoint: EndPoint,
                      page: Int,
                      completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listMoviesAPI.getListMovies(endPoint: endPoint.rawValue,
                                    movieId: nil, page: page,
                                    queryString: nil) { responseResult in
            switch responseResult {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void) {
        detailMovieAPI.getDetailMovie(movieId: movieId, completion: completion)
    }
}
