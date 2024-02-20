//
//  UpComingContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol UpComingContract {
    typealias Model = UpComingModelProtocol
    typealias View = UpComingViewProtocol
    typealias Presenter = UpComingPresenterProtocol
}

protocol UpComingModelProtocol {
    func getListMovie(page: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol UpComingViewProtocol: AnyObject {
    func set(presenter: UpComingPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol UpComingPresenterProtocol {
    func fetchData(_ page: Int, completion: @escaping () -> Void)
    func fetchMoreData(completion: @escaping () -> Void)
    func refreshData(completion: @escaping () -> Void)
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
}
