//
//  GetCreditMovieAPI.swift
//  SmartMovie
//
//  Created by BachNguyen on 06/04/2023.
//

import Foundation

protocol GetCreditMovieAPIProtocol {
    func getCreditMovie(movieId: Int, completion: @escaping (Result<ListCreditResponseEntity, APIError>) -> Void)
}

final class GetCreditMovieAPI: BaseAPIFetcher {
    private let baseURL = ServerConstant.URLBase.baseURL
    private let apiKey = ServerConstant.APIKey.apiKey
}

extension GetCreditMovieAPI: GetCreditMovieAPIProtocol {
    func getCreditMovie(movieId: Int, completion: @escaping (Result<ListCreditResponseEntity, APIError>) -> Void) {
        let url = "\(baseURL)\(EndPoint.movie.rawValue)\(movieId)\(EndPoint.credit.rawValue)\(apiKey)"
        fetchData(url: url, movieId: movieId, page: nil, queryString: nil, completion: completion)
    }
}
