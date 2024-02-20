//
//  TopRatedCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class TopRatedCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         parent: Coordinator? = nil) {
        self.navigationController = navigationController
    }
}

extension TopRatedCoordinator: Coordinator {
    func startTopRated(data: Any? = nil) -> TopRatedViewController {
        let scene = UIStoryboard(name: "TopRated", bundle: nil).instantiate(TopRatedViewController.self)
        let presenter = TopRatedPresenter(model: TopRatedModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: "TopRated", bundle: nil).instantiate(TopRatedViewController.self)
        let presenter = TopRatedPresenter(model: TopRatedModel(),
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
