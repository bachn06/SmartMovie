//
//  UpComingCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class UpComingCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         parent: Coordinator? = nil) {
        self.navigationController = navigationController
    }
}

extension UpComingCoordinator: Coordinator {
    func startUpComing(data: Any? = nil) -> UpComingViewController {
        let scene = UIStoryboard(name: "UpComing", bundle: nil).instantiate(UpComingViewController.self)
        let presenter = UpComingPresenter(model: UpComingModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: "UpComing", bundle: nil).instantiate(UpComingViewController.self)
        let presenter = UpComingPresenter(model: UpComingModel(),
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
