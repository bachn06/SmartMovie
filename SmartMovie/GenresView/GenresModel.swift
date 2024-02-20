//
//  GenresModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//
//

import Foundation

struct GenresViewEntity {
    let id: Int?
    let name: String?

    init(id: Int? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }

    init(response: GenreResponseEntity) {
        self.id = response.id
        self.name = response.name
    }
}

final class GenresModel {
    private let listGenresAPI: GetGenreMovieAPIProtocol = GetGenreMovieAPI()
}

extension GenresModel: GenresModelProtocol {
    func getGenres(result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void) {
        listGenresAPI.getGenres { responseResult in
            switch responseResult {
            case .success(let data):
                result(.success(data.genres ?? []))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}
