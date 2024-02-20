//
//  PopularCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class PopularCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         parent: Coordinator? = nil) {
        self.navigationController = navigationController
    }
}

extension PopularCoordinator: Coordinator {
    func startPopular(data: Any? = nil) -> PopularViewController {
        let scene = UIStoryboard(name: AppConstant.Storyboard.popular,
                                 bundle: nil).instantiate(PopularViewController.self)
        let presenter = PopularPresenter(model: PopularModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: AppConstant.Storyboard.popular,
                                 bundle: nil).instantiate(PopularViewController.self)
        let presenter = PopularPresenter(model: PopularModel(),
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
