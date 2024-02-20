//
//  GenresCoordinator.swift
//  HondaConnect
//
//  Created by BachNguyen on 23/05/2023.
//

import UIKit

final class GenresCoordinator: BaseCoordinator {

}

extension GenresCoordinator: Coordinator {
    func startGenres(data: Any? = nil) -> GenresViewController {
        let scene = UIStoryboard(name: "Genres", bundle: nil).instantiate(GenresViewController.self)
        let presenter = GenresPresenter(model: GenresModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }
    func start(data: Any?) {
        let scene = UIStoryboard(name: "Genres", bundle: nil).instantiate(GenresViewController.self)
        let presenter = GenresPresenter(model: GenresModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        navigationController.pushViewController(scene, animated: true)
    }
    func getListGenreMovies(genre: GenresViewEntity) {
        let genreMoviesCoordinator = GenreMoviesCoordinator(navigationController: navigationController)
        genreMoviesCoordinator.start(data: genre)
    }
    func back() {
        navigationController.popViewController(animated: true)
    }
}
