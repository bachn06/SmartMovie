//
//  GetGenreMovieAPI.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import Foundation

protocol GetGenreMovieAPIProtocol {
    func getGenres(completion: @escaping (Result<ListGenreResponseEntity, APIError>) -> Void)
    func getMoviesByGenre(genreId: Int,
                          page: Int,
                          completion: @escaping (Result<ListMoviesResponseEntity, APIError>) -> Void)
}

final class GetGenreMovieAPI: BaseAPIFetcher {
    private let baseURL = ServerConstant.URLBase.baseURL
    private let apiKey = ServerConstant.APIKey.apiKey
}

extension GetGenreMovieAPI: GetGenreMovieAPIProtocol {
    func getGenres(completion: @escaping (Result<ListGenreResponseEntity, APIError>) -> Void) {
        let url = "\(baseURL)\(EndPoint.genres.rawValue)\(apiKey)"
        fetchData(url: url, movieId: nil, page: nil, queryString: nil, completion: completion)
    }

    func getMoviesByGenre(genreId: Int,
                          page: Int,
                          completion: @escaping (Result<ListMoviesResponseEntity, APIError>) -> Void) {
        let url = "\(baseURL)\(EndPoint.discover.rawValue)\(apiKey)&with_genres=\(genreId)&page=\(page)"
        fetchData(url: url, movieId: nil, page: page, queryString: nil, completion: completion)
    }
}
