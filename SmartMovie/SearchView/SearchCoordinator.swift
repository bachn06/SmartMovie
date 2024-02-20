//
//  SearchCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class SearchCoordinator: BaseCoordinator {

}

extension SearchCoordinator: Coordinator {
    func startSearch(data: Any? = nil) -> SearchViewController {
        let scene = UIStoryboard(name: "Search", bundle: nil).instantiate(SearchViewController.self)
        let presenter = SearchPresenter(model: SearchModel(),
                                        view: scene,
                                        coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any?) {
        let scene = UIStoryboard(name: "Search", bundle: nil).instantiate(SearchViewController.self)
        let presenter = SearchPresenter(model: SearchModel(),
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
