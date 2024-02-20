//
//  MoviesCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class MoviesCoordinator: BaseCoordinator {

}

extension MoviesCoordinator: Coordinator {
    func startMovies(data: Any? = nil) -> MoviesViewController {
        let scene = UIStoryboard(name: AppConstant.Storyboard.movies,
                                 bundle: nil).instantiate(MoviesViewController.self)
        let presenter = MoviesPresenter(model: MoviesModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: AppConstant.Storyboard.movies,
                                 bundle: nil).instantiate(MoviesViewController.self)
        let presenter = MoviesPresenter(model: MoviesModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
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
