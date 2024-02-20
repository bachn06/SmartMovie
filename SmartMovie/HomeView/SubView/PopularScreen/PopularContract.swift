//
//  PopularContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol PopularContract {
    typealias Model = PopularModelProtocol
    typealias View = PopularViewProtocol
    typealias Presenter = PopularPresenterProtocol
}

protocol PopularModelProtocol {
    func getListMovie(page: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol PopularViewProtocol: AnyObject {
    func set(presenter: PopularPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol PopularPresenterProtocol {
    func fetchData(_ page: Int, completion: @escaping () -> Void)
    func fetchMoreData(completion: @escaping () -> Void)
    func refreshData(completion: @escaping () -> Void)
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
}
