//
//  DetailModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import Foundation

struct DetailViewEntity {
    let name: String
    let profilePath: String
    init() {
        self.name = ""
        self.profilePath = ""
    }
    init(response: CreditResponseEntity) {
        self.name = response.name ?? response.originalName ?? ""
        self.profilePath = response.profilePath ?? ""
    }
}

final class DetailModel {
    private let listMovieAPI: GetListMoviesAPIProtocol = GetListMovieAPI()
    private let detailMovieAPI: GetDetailMovieAPIProtocol = GetDetailMovieAPI()
    private let castingMovieAPI: GetCreditMovieAPIProtocol = GetCreditMovieAPI()
}

extension DetailModel: DetailModelProtocol {
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void) {
        detailMovieAPI.getDetailMovie(movieId: movieId, completion: completion)
    }
    func getCastingMovie(movieId: Int, completion: @escaping (Result<[CreditResponseEntity], APIError>) -> Void) {
        castingMovieAPI.getCreditMovie(movieId: movieId) { responseResult in
            switch responseResult {
            case .success(let data):
                completion(.success(data.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getSimilarMovies(movieId: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void) {
        listMovieAPI.getListMovies(endPoint: EndPoint.similar.rawValue,
                                   movieId: movieId, page: nil,
                                   queryString: nil) { result in
            switch result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
