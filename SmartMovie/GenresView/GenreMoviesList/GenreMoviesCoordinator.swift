//
//  GenreMoviesCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class GenreMoviesCoordinator: BaseCoordinator {

}

extension GenreMoviesCoordinator: Coordinator {
    func start(data: Any? = nil) {
        guard let data = data as? GenresViewEntity else { return }
        let scene = UIStoryboard(name: "GenreMovies", bundle: nil).instantiate(GenreMoviesViewController.self)
        let presenter = GenreMoviesPresenter(model: GenreMoviesModel(),
                                             view: scene,
                                             coordinator: self)
        scene.set(presenter: presenter)
        presenter.setGenreId(data.id ?? 0)
        presenter.fetchGenreMovies(genreId: data.id ?? 0, page: 1) {
            presenter.setUpUI()
        }
        scene.title = data.name
        navigationController.navigationBar.tintColor = .red
        navigationController.pushViewController(scene, animated: true)
    }
    func navigateToDetail(movie: MovieDisplayModel) {
        let detailMoviesCoordinator = DetailCoordinator(navigationController: navigationController)
        detailMoviesCoordinator.start(data: movie)
    }
    func back() {
        navigationController.popViewController(animated: true)
    }
}
