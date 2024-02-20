//
//  UpComingModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

struct UpComingViewEntity {

}

final class UpComingModel {
    private let listMoviesAPI: GetListMoviesAPIProtocol = GetListMovieAPI()
    private let detailMovieAPI: GetDetailMovieAPIProtocol = GetDetailMovieAPI()
}

extension UpComingModel: UpComingModelProtocol {
    func getListMovie(page: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listMoviesAPI.getListMovies(endPoint: EndPoint.upComing.rawValue,
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
