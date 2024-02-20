//
//  NowPlayingCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class NowPlayingCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         parent: Coordinator? = nil) {
        self.navigationController = navigationController
    }
}

extension NowPlayingCoordinator: Coordinator {
    func startNowPlaying(data: Any? = nil) -> NowPlayingViewController {
        let scene = UIStoryboard(name: "NowPlaying", bundle: nil).instantiate(NowPlayingViewController.self)
        let presenter = NowPlayingPresenter(model: NowPlayingModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: "NowPlaying", bundle: nil).instantiate(NowPlayingViewController.self)
        let presenter = NowPlayingPresenter(model: NowPlayingModel(),
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
