//
//  MoviesContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol MoviesContract {
    typealias Model = MoviesModelProtocol
    typealias View = MoviesViewProtocol
    typealias Presenter = MoviesPresenterProtocol
}

protocol MoviesModelProtocol {
    func getListMovie(endPoint: EndPoint,
                      page: Int,
                      completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol MoviesViewProtocol: AnyObject {
    func set(presenter: MoviesPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol MoviesPresenterProtocol {
    func fetchData(completion: @escaping () -> Void)
    func refreshData(completion: @escaping () -> Void)
    func numberOfSection() -> Int
    func numberOfItemInSection(section: Int) -> Int
    func getSectionTitle(section: Int) -> String
    func cellForItemAt(section: Int, index: Int) -> MovieDisplayModel
    func didSelectItemAt(section: Int, index: Int)
}
