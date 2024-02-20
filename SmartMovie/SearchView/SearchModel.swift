//
//  SearchModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//
//

import Foundation

struct SearchViewEntity {
    let id: Int?

    init(response: MovieResponseEntity) {
        self.id = response.id
    }
}

final class SearchModel {
    private let listMoviesAPI: GetListMoviesAPIProtocol = GetListMovieAPI()
    private let detailMovieAPI: GetDetailMovieAPIProtocol = GetDetailMovieAPI()
}

extension SearchModel: SearchModelProtocol {
    func getSearchResult(endPoint: EndPoint,
                         queryString: String,
                         completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listMoviesAPI.getListMovies(endPoint: endPoint.rawValue,
                                    movieId: nil,
                                    page: nil,
                                    queryString: queryString) { responseResult in
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
