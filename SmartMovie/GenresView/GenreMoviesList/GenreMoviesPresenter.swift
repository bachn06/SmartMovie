//
//  GenreMoviesPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import Foundation

final class GenreMoviesPresenter {
    private weak var contentView: GenreMoviesContract.View?
    private var model: GenreMoviesContract.Model
    private let coordinator: GenreMoviesCoordinator
    private var listMovies: [MovieDisplayModel] = []
    private let dispatchGroup = DispatchGroup()
    private var genreId: Int = 0
    private var page: Int = 1

    init(model: GenreMoviesContract.Model,
         view: GenreMoviesContract.View,
         coordinator: GenreMoviesCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension GenreMoviesPresenter: GenreMoviesPresenterProtocol {
    func fetchGenreMovies(genreId: Int, page: Int, completion: @escaping () -> Void) {
        dispatchGroup.enter()
        model.getGenreMovies(genreId: genreId, page: page) { [weak self] responseResult in
            switch responseResult {
            case .success(let listMoviesResponse):
                let dispatchGroup = DispatchGroup()
                var movies: [MovieDisplayModel] = []
                for movie in listMoviesResponse {
                    dispatchGroup.enter()
                    self?.getDetailMovie(movie: movie) { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .success(let detailMovieResponse):
                            movies.append(detailMovieResponse)
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async {
                                self?.contentView?.displayError {
                                    self?.fetchGenreMovies(genreId: genreId, page: page, completion: completion)
                                }
                            }
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self?.listMovies.append(contentsOf: movies)
                    self?.contentView?.reloadData()
                    self?.dispatchGroup.leave()
                    completion()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        self?.fetchGenreMovies(genreId: genreId, page: page, completion: completion)
                    }
                }
                self?.dispatchGroup.leave()
                completion()
            }
        }
    }

    func fetchMoreData(completion: @escaping () -> Void) {
        page += 1
        fetchGenreMovies(genreId: self.genreId, page: self.page, completion: completion)
    }

    func setGenreId(_ genreID: Int) {
        genreId = genreID
    }

    func numberOfItemInSection() -> Int {
        return listMovies.count
    }

    func cellForItemAt(index: Int) -> MovieDisplayModel {
        if listMovies.isEmpty == false {
            return listMovies[index]
        }
        return MovieDisplayModel()
    }

    func didSelectItemAt(index: Int) {
        if listMovies.isEmpty == false {
            coordinator.navigateToDetail(movie: listMovies[index])
        }
    }

    func setUpUI() {
        contentView?.setUpUI()
    }
}

extension GenreMoviesPresenter {
    func getDetailMovie(movie: MovieResponseEntity,
                        completion: @escaping (Result<MovieDisplayModel, APIError>) -> Void) {
        model.getDetailMovie(movieId: movie.id ?? 0) { result in
            switch result {
            case .success(let detailMovieResponse):
                completion(.success(MovieDisplayModel(response: detailMovieResponse)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
