//
//  GetListMoviesAPI.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol GetListMoviesAPIProtocol {
    func getListMovies(endPoint: EndPoint.RawValue,
                       movieId: Int?,
                       page: Int?,
                       queryString: String?,
                       completion: @escaping (Result<ListMoviesResponseEntity, APIError>) -> Void)
}

final class GetListMovieAPI: BaseAPIFetcher {
    private let baseURL = ServerConstant.URLBase.baseURL
    private let apiKey = ServerConstant.APIKey.apiKey
}

extension GetListMovieAPI: GetListMoviesAPIProtocol {
    func getListMovies(endPoint: EndPoint.RawValue,
                       movieId: Int?,
                       page: Int?,
                       queryString: String?,
                       completion: @escaping (Result<ListMoviesResponseEntity, APIError>) -> Void) {
        guard let endPointCase = EndPoint(rawValue: endPoint) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var url = ""
        switch endPointCase {
        case .popular, .topRated, .upComing, .nowPlaying:
            guard let page = page else {
                completion(.failure(.missingParameters))
                return
            }
            url = "\(baseURL)\(endPoint)\(apiKey)&page=\(page)"
        case .search:
            guard let queryString = queryString else {
                completion(.failure(.missingParameters))
                return
            }
            let encodedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            url = "\(baseURL)\(endPoint)\(apiKey)&query=\(encodedQuery)"
        case .similar:
            guard let movieId = movieId else {
                completion(.failure(.missingParameters))
                return
            }
            url = "\(baseURL)\(EndPoint.movie.rawValue)\(movieId)\(endPoint)\(apiKey)"
        default:
            break
        }
        fetchData(url: url, movieId: movieId, page: page, queryString: queryString, completion: completion)
    }

}
