//
//  GenresContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

protocol GenresContract {
    typealias Model = GenresModelProtocol
    typealias View = GenresViewProtocol
    typealias Presenter = GenresPresenterProtocol
}

protocol GenresModelProtocol {
    func getGenres(result: @escaping (Result<[GenreResponseEntity], APIError>) -> Void)
}

protocol GenresViewProtocol: AnyObject {
    func set(presenter: GenresPresenterProtocol)
    func reloadData()
    func displayError(completion: @escaping () -> Void)
}

protocol GenresPresenterProtocol {
    func fetchGenreData()
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> GenresViewEntity
    func didSelectItemAt(index: Int)
}
