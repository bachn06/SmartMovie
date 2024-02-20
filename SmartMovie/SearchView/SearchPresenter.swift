//
//  SearchPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

final class SearchPresenter {
    private weak var contentView: SearchContract.View?
    private var model: SearchContract.Model
    private let coordinator: SearchCoordinator
    private var listSearchMovies: [MovieDisplayModel] = []
    private let dispatchGroup = DispatchGroup()

    init(model: SearchContract.Model,
         view: SearchContract.View,
         coordinator: SearchCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func fetchSearchResult(query: String, completion: @escaping () -> Void) {
        listSearchMovies.removeAll()
        contentView?.reloadData()
        model.getSearchResult(endPoint: .search, queryString: query) { [weak self] responseResult in
            switch responseResult {
            case .success(let listMoviesResponse):
                let movieCount = listMoviesResponse.count
                let group = DispatchGroup()
                for index in 0..<movieCount {
                    group.enter()
                    self?.getDetailMovie(movie: listMoviesResponse[index]) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let detailMovieResponse):
                            DispatchQueue.main.async {
                                self?.listSearchMovies.append(detailMovieResponse)
                                self?.contentView?.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async {
                                self?.contentView?.displayError {
                                    completion()
                                }
                            }
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        completion()
                    }
                }
            }
        }
    }

    func resultSearchMovies() -> [MovieDisplayModel] {
        return listSearchMovies
    }

    func numberOfRowInSection() -> Int {
        return listSearchMovies.count
    }

    func didSelectItemAt(index: Int) {
        if listSearchMovies.isEmpty == false {
            coordinator.navigateToDetail(movie: listSearchMovies[index])
        }
    }

    func cancelSearch() {
        listSearchMovies.removeAll()
        DispatchQueue.main.async {
            self.contentView?.reloadData()
        }
    }

    func cellForRowAt(index: Int) -> MovieDisplayModel {
        if listSearchMovies.isEmpty == false {
            return listSearchMovies[index]
        }
        return MovieDisplayModel()
    }
}

extension SearchPresenter {
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
