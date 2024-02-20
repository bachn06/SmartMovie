//
//  PopularPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

final class PopularPresenter {
    private weak var contentView: PopularContract.View?
    private var model: PopularContract.Model
    private let coordinator: PopularCoordinator
    private var page: Int = 1
    private var listPopularMovies: [MovieDisplayModel] = []
    private let dispatchGroup = DispatchGroup()

    init(model: PopularContract.Model,
         view: PopularContract.View,
         coordinator: PopularCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension PopularPresenter: PopularPresenterProtocol {
    func fetchData(_ page: Int, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        var movies: [MovieDisplayModel] = []

        dispatchGroup.enter()
        model.getListMovie(page: page) { [weak self] responseResult in
            guard let self = self else { return }

            switch responseResult {
            case .success(let listMoviesResponse):
                for movie in listMoviesResponse {
                    dispatchGroup.enter()
                    self.getDetailMovie(movie: movie) { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .success(let detailMovieResponse):
                            movies.append(detailMovieResponse)
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async {
                                self.contentView?.displayError {
                                    self.fetchData(page, completion: completion)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.contentView?.displayError {
                        self.fetchData(page, completion: completion)
                    }
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            self.listPopularMovies.append(contentsOf: movies)
            DispatchQueue.main.async {
                self.contentView?.reloadData()
                completion()
            }
        }
    }

    func refreshData(completion: @escaping () -> Void) {
        listPopularMovies.removeAll()
        page = 1
        fetchData(page, completion: completion)
    }

    func fetchMoreData(completion: @escaping () -> Void) {
        page += 1
        fetchData(self.page, completion: completion)
    }

    func numberOfItemInSection() -> Int {
        return listPopularMovies.count
    }

    func cellForItemAt(index: Int) -> MovieDisplayModel {
        if listPopularMovies.isEmpty {
            return MovieDisplayModel()
        }
        return listPopularMovies[index]
    }

    func didSelectItemAt(index: Int) {
        if listPopularMovies.isEmpty {
            return
        }
        coordinator.navigateToDetail(movie: listPopularMovies[index])
    }
}

extension PopularPresenter {
    private func getDetailMovie(movie: MovieResponseEntity,
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
