//
//  GetDetailMovieAPI.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import Foundation

protocol GetDetailMovieAPIProtocol {
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

final class GetDetailMovieAPI: BaseAPIFetcher {
    private let baseURL = ServerConstant.URLBase.baseURL
    private let apiKey = ServerConstant.APIKey.apiKey
}

extension GetDetailMovieAPI: GetDetailMovieAPIProtocol {
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void) {
        let url = "\(baseURL)\(EndPoint.movie.rawValue)\(movieId)\(apiKey)"
        fetchData(url: url, movieId: movieId, page: nil, queryString: nil, completion: completion)
    }
}
