//
//  BaseAPIFetcher.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

public enum APIError: Error {
    case unknownError
    case serverError
    case encodeParamsFailed
    case decodeDataFailed
    case invalidEndpoint
    case missingParameters
}

public enum EndPoint: String {
    case movie = "movie/"
    case popular = "movie/popular"
    case topRated = "movie/top_rated"
    case upComing = "movie/upcoming"
    case nowPlaying = "movie/now_playing"
    case credit = "/credits"
    case search = "search/movie"
    case genres = "genre/movie/list"
    case discover = "discover/movie"
    case similar = "/similar"
}

protocol APIFetcherProtocol {
}

class BaseAPIFetcher: APIFetcherProtocol {
    let networkServices: NetworkServicesProtocol
    init(networkServices: NetworkServicesProtocol = NetworkServices()) {
        self.networkServices = networkServices
    }
    func decodeData<T: Decodable>(_ data: Data, type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let response: T = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch let error {
            print(error)
            throw APIError.decodeDataFailed
        }
    }

    func fetchData<T: Decodable>(url: String,
                                 movieId: Int?,
                                 page: Int?,
                                 queryString: String?,
                                 completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.decodeDataFailed))
            return
        }
        let requestInfo: RequestInfo = RequestInfo(urlInfo: url, httpMethod: .get, params: nil)
        networkServices.request(info: requestInfo) { [weak self] (responseResult) in
            guard let self = self else {
                completion(.failure(.unknownError))
                return
            }
            switch responseResult {
            case .success(let data):
                do {
                    let responseEntity = try self.decodeData(data, type: T.self)
                    completion(.success(responseEntity))
                } catch {
                    completion(.failure(.decodeDataFailed))
                }
            case .failure(let error):
                print(error)
                completion(.failure(.decodeDataFailed))
            }
        }
    }
}
