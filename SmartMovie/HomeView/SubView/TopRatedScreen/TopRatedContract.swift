//
//  TopRatedContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol TopRatedContract {
    typealias Model = TopRatedModelProtocol
    typealias View = TopRatedViewProtocol
    typealias Presenter = TopRatedPresenterProtocol
}

protocol TopRatedModelProtocol {
    func getListMovie(page: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol TopRatedViewProtocol: AnyObject {
    func set(presenter: TopRatedPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol TopRatedPresenterProtocol {
    func fetchData(_ page: Int, completion: @escaping () -> Void)
    func fetchMoreData(completion: @escaping () -> Void)
    func refreshData(completion: @escaping () -> Void)
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
}
