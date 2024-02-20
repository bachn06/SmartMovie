//
//  DetailContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import Foundation

protocol DetailContract {
    typealias Model = DetailModelProtocol
    typealias View = DetailViewProtocol
    typealias Presenter = DetailPresenterProtocol
}

protocol DetailModelProtocol {
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
    func getCastingMovie(movieId: Int, completion: @escaping (Result<[CreditResponseEntity], APIError>) -> Void)
    func getSimilarMovies(movieId: Int, completion: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
}

protocol DetailViewProtocol: AnyObject {
    func set(presenter: DetailPresenterProtocol)
    func reloadData()
    func setupData(_ data: MovieDisplayModel)
    func displayError(completion: @escaping () -> Void)
}

protocol DetailPresenterProtocol {
    func fetchData(movieId: Int, completion: @escaping () -> Void)
    func setData()
    func numberOfSection() -> Int
    func titleForHeaderInSection(_ section: Int) -> String
    func heightForHeaderInSection(_ section: Int) -> CGFloat
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellIdentifierForRowAt(_ indexPath: IndexPath) -> String
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
    func cellForRowAt(_ indexPath: IndexPath) -> Any
    func back()
}
