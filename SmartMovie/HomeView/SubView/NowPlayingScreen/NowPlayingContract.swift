//
//  NowPlayingContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol NowPlayingContract {
    typealias Model = NowPlayingModelProtocol
    typealias View = NowPlayingViewProtocol
    typealias Presenter = NowPlayingPresenterProtocol
}

protocol NowPlayingModelProtocol {
    func getListMovie(page: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol NowPlayingViewProtocol: AnyObject {
    func set(presenter: NowPlayingPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol NowPlayingPresenterProtocol {
    func fetchData(_ page: Int, completion: @escaping () -> Void)
    func fetchMoreData(completion: @escaping () -> Void)
    func refreshData(completion: @escaping () -> Void)
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
}
