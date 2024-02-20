//
//  MoviesPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

final class MoviesPresenter {
    private weak var contentView: MoviesContract.View?
    private var model: MoviesContract.Model
    private let coordinator: MoviesCoordinator
    private var successfulFetch: Bool = false
    private let page: Int = 1
    private var sectionTitle: [String] = []
    private var listPopularMovies: [MovieDisplayModel] = []
    private var listTopRatedMovies: [MovieDisplayModel] = []
    private var listUpComingMovies: [MovieDisplayModel] = []
    private var listNowPlayingMovies: [MovieDisplayModel] = []
    private let dispatchGroup = DispatchGroup()
    init(model: MoviesContract.Model,
         view: MoviesContract.View,
         coordinator: MoviesCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension MoviesPresenter: MoviesPresenterProtocol {
    func fetchData(completion: @escaping () -> Void) {
        fetchPopularMovies()
        fetchTopRatedMovies()
        fetchUpComingMovies()
        fetchNowPlayingMovies()
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                if self.successfulFetch {
                    self.contentView?.reloadData()
                } else {
                    self.contentView?.displayError {
                        self.fetchData(completion: completion)
                    }
                }
            }
            completion()
        }
    }

    func refreshData(completion: @escaping () -> Void) {
        listPopularMovies.removeAll()
        listTopRatedMovies.removeAll()
        listUpComingMovies.removeAll()
        listNowPlayingMovies.removeAll()
        fetchData(completion: completion)
    }

    func numberOfSection() -> Int {
        return sectionTitle.count
    }

    func numberOfItemInSection(section: Int) -> Int {
        switch sectionTitle[section] {
        case AppConstant.Title.popular:
            if listPopularMovies.count > 4 {
                return 4
            } else {
                return listPopularMovies.count
            }
        case AppConstant.Title.topRated:
            if listTopRatedMovies.count > 4 {
                return 4
            } else {
                return listTopRatedMovies.count
            }
        case AppConstant.Title.upComing:
            if listUpComingMovies.count > 4 {
                return 4
            } else {
                return listUpComingMovies.count
            }
        case AppConstant.Title.nowPlaying:
            if listNowPlayingMovies.count > 4 {
                return 4
            } else {
                return listNowPlayingMovies.count
            }
        default:
            return 0
        }
    }

    func cellForItemAt(section: Int, index: Int) -> MovieDisplayModel {
        switch sectionTitle[section] {
        case AppConstant.Title.popular:
            if listPopularMovies.isEmpty == false {
                return listPopularMovies[index]
            }
        case AppConstant.Title.topRated:
            if listTopRatedMovies.isEmpty == false {
                return listTopRatedMovies[index]
            }
        case AppConstant.Title.upComing:
            if listUpComingMovies.isEmpty == false {
                return listUpComingMovies[index]
            }
        case AppConstant.Title.nowPlaying:
            if listNowPlayingMovies.isEmpty == false {
                return listNowPlayingMovies[index]
            }
        default:
            return MovieDisplayModel()
        }
        return MovieDisplayModel()
    }

    func didSelectItemAt(section: Int, index: Int) {
        switch sectionTitle[section] {
        case AppConstant.Title.popular:
            if listPopularMovies.isEmpty == false {
                coordinator.navigateToDetail(movie: listPopularMovies[index])
            }
        case AppConstant.Title.topRated:
            if listTopRatedMovies.isEmpty == false {
                coordinator.navigateToDetail(movie: listTopRatedMovies[index])
            }
        case AppConstant.Title.upComing:
            if listUpComingMovies.isEmpty == false {
                coordinator.navigateToDetail(movie: listUpComingMovies[index])
            }
        case AppConstant.Title.nowPlaying:
            if listNowPlayingMovies.isEmpty == false {
                coordinator.navigateToDetail(movie: listNowPlayingMovies[index])
            }
        default:
            break
        }
    }

    func getSectionTitle(section: Int) -> String {
        return sectionTitle[section]
    }
}

extension MoviesPresenter {
    private func fetchPopularMovies() {
        fetchMovies(endPoint: .popular) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.listPopularMovies = movies
                self?.successfulFetch = true
                if self?.sectionTitle.contains(AppConstant.Title.popular) == false {
                    self?.sectionTitle.append(AppConstant.Title.popular)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("appendPopular"), object: nil)
                    }
                }
            case .failure(let error):
                print(error)
                self?.successfulFetch = false
            }
        }
    }

    private func fetchTopRatedMovies() {
        fetchMovies(endPoint: .topRated) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.listTopRatedMovies = movies
                self?.successfulFetch = true
                if self?.sectionTitle.contains(AppConstant.Title.topRated) == false {
                    self?.sectionTitle.append(AppConstant.Title.topRated)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("appendTopRated"), object: nil)
                    }
                }
            case .failure(let error):
                print(error)
                self?.successfulFetch = false
            }
        }
    }

    private func fetchUpComingMovies() {
        fetchMovies(endPoint: .upComing) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.listUpComingMovies = movies
                self?.successfulFetch = true
                if self?.sectionTitle.contains(AppConstant.Title.upComing) == false {
                    self?.sectionTitle.append(AppConstant.Title.upComing)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("appendUpComing"), object: nil)
                    }
                }
            case .failure(let error):
                print(error)
                self?.successfulFetch = false
            }
        }
    }

    private func fetchNowPlayingMovies() {
        fetchMovies(endPoint: .nowPlaying) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.listNowPlayingMovies = movies
                self?.successfulFetch = true
                if self?.sectionTitle.contains(AppConstant.Title.nowPlaying) == false {
                    self?.sectionTitle.append(AppConstant.Title.nowPlaying)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("appendNowPlaying"), object: nil)
                    }
                }
            case .failure(let error):
                print(error)
                self?.successfulFetch = false
            }
        }
    }

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

    private func fetchMovies(endPoint: EndPoint,
                             completion: @escaping (Result<[MovieDisplayModel], APIError>) -> Void) {
        dispatchGroup.enter()
        model.getListMovie(endPoint: endPoint, page: page) { [weak self] responseResult in
            guard let self = self else { return }
            defer { self.dispatchGroup.leave() }

            switch responseResult {
            case .success(let listMoviesResponse):
                let dispatchGroup = DispatchGroup()
                var movies: [MovieDisplayModel] = []
                for movie in listMoviesResponse {
                    dispatchGroup.enter()
                    self.getDetailMovie(movie: movie) { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .success(let detailMovieResponse):
                            movies.append(detailMovieResponse)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
                    completion(.success(movies))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
