//
//  SearchContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol SearchContract {
    typealias Model = SearchModelProtocol
    typealias View = SearchViewProtocol
    typealias Presenter = SearchPresenterProtocol
}

protocol SearchModelProtocol {
    func getSearchResult(endPoint: EndPoint,
                         queryString: String,
                         completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol SearchViewProtocol: AnyObject {
    func set(presenter: SearchPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol SearchPresenterProtocol {
    func fetchSearchResult(query: String, completion: @escaping () -> Void)
    func resultSearchMovies() -> [MovieDisplayModel]
    func numberOfRowInSection() -> Int
    func cellForRowAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
    func cancelSearch()
}
