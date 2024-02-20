//
//  DetailPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import Foundation

final class DetailPresenter {
    private weak var contentView: DetailContract.View?
    private var model: DetailContract.Model
    private let coordinator: DetailCoordinator
    private var movies: MovieDisplayModel = MovieDisplayModel()
    private var casting: [CastingDisplayModel] = []
    private var similarMovies: [MovieDisplayModel] = []
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    init(model: DetailContract.Model,
         view: DetailContract.View,
         coordinator: DetailCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func fetchData(movieId: Int, completion: @escaping () -> Void) {
        getDetailMovie(movieId: movieId)
        getCastingMovie(movieId: movieId)
        getSimilarMovie(movieId: movieId)
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.contentView?.reloadData()
            }
            completion()
        }
    }

    private func getDetailMovie(movieId: Int) {
        dispatchGroup.enter()
        model.getDetailMovie(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                let result: MovieDisplayModel = MovieDisplayModel(response: response)
                DispatchQueue.main.async {
                    self?.movies = result
                }
                self?.dispatchGroup.leave()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        self?.getDetailMovie(movieId: movieId)
                    }
                }
                self?.dispatchGroup.leave()
            }
        }
    }

    private func getCastingMovie(movieId: Int) {
        dispatchGroup.enter()
        model.getCastingMovie(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                 var cast: [CastingDisplayModel] = []
                 response.forEach { result in
                     cast.append(CastingDisplayModel(response: result))
                 }
                 DispatchQueue.main.async {
                     self?.casting = cast
                 }
                self?.dispatchGroup.leave()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        self?.getCastingMovie(movieId: movieId)
                    }
                }
                self?.dispatchGroup.leave()
            }
        }
    }

    private func getSimilarMovie(movieId: Int) {
        model.getSimilarMovies(movieId: movieId) { [weak self] responseResult in
            switch responseResult {
            case .success(let listMoviesResponse):
                let dispatchGroup = DispatchGroup()
                let queue = DispatchQueue(label: "getSimilarMovies")
                var similarMovies = [MovieDisplayModel]()
                for movie in listMoviesResponse {
                    dispatchGroup.enter()
                    queue.async {
                        self?.getMovieDetail(movie: movie) { result in
                            switch result {
                            case .success(let detailMovieResponse):
                                similarMovies.append(detailMovieResponse)
                            case .failure(let error):
                                print(error)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self?.similarMovies = similarMovies
                    self?.contentView?.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        self?.getSimilarMovie(movieId: movieId)
                    }
                }
            }
        }
    }

    func setData() {
        contentView?.setupData(self.movies)
    }

    func getMovieDetail(movie: MovieResponseEntity,
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

    func numberOfSection() -> Int {
        if casting.isEmpty && similarMovies.isEmpty {
            return 0
        } else if casting.isEmpty || similarMovies.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return similarMovies.isEmpty ? 0 : similarMovies.count
        }
    }

    func titleForHeaderInSection(_ section: Int) -> String {
        if section == 0 {
            return casting.isEmpty ? "" : "Casting"
        } else {
            return similarMovies.isEmpty ? "" : "Similar Movies"
        }
    }

    func heightForHeaderInSection(_ section: Int) -> CGFloat {
        if section == 0 {
            return casting.isEmpty ? 0 : 50
        } else {
            return similarMovies.isEmpty ? 0 : 50
        }
    }

    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if casting.count == 0 {
                return 0
            } else if casting.count < 8 {
                return 150
            } else {
                return 300
            }
        } else {
            return similarMovies.isEmpty ? 0 : 300
        }
    }

    func cellIdentifierForRowAt(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return "DetailTableViewCell"
        } else {
            return "SearchTableViewCell"
        }
    }

    func cellForRowAt(_ indexPath: IndexPath) -> Any {
        if indexPath.section == 0 {
            return casting
        } else {
            return similarMovies[indexPath.row]
        }
    }

    func back() {
        coordinator.back()
    }
}
