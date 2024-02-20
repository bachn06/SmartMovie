//
//  GenreMoviesContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import Foundation

protocol GenreMoviesContract {
    typealias Model = GenreMoviesModelProtocol
    typealias View = GenreMoviesViewProtocol
    typealias Presenter = GenreMoviesPresenterProtocol
}

protocol GenreMoviesModelProtocol {
    func getGenreMovies(genreId: Int, page: Int, result: @escaping (Result<[MovieResponseEntity], APIError>) -> Void)
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieResponseEntity, APIError>) -> Void)
}

protocol GenreMoviesViewProtocol: AnyObject {
    func set(presenter: GenreMoviesPresenterProtocol)
    func reloadData()
    func setUpUI()
    func displayError(completion: @escaping () -> Void)
}

protocol GenreMoviesPresenterProtocol {
    func setUpUI()
    func fetchGenreMovies(genreId: Int, page: Int, completion: @escaping () -> Void)
    func fetchMoreData(completion: @escaping () -> Void)
    func numberOfItemInSection() -> Int
    func cellForItemAt(index: Int) -> MovieDisplayModel
    func didSelectItemAt(index: Int)
}
