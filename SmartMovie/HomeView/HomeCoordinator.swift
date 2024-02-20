//
//  HomeCoordinator.swift
//  HondaConnect
//
//  Created by BachNguyen on 23/05/2023.
//

import Foundation
import UIKit

class HomeCoordinator: BaseCoordinator {

}

extension HomeCoordinator {
    func startHome(data: Any? = nil) -> HomeViewController {
        let scene = UIStoryboard(name: AppConstant.Storyboard.home, bundle: nil).instantiate(HomeViewController.self)
        let presenter = HomePresenter(model: HomeModel(),
                                      view: scene,
                                      coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any? = nil) {
        let scene = UIStoryboard(name: AppConstant.Storyboard.home, bundle: nil).instantiate(HomeViewController.self)
        let presenter = HomePresenter(model: HomeModel(),
                                      view: scene,
                                      coordinator: self)
        scene.set(presenter: presenter)
        navigationController.pushViewController(scene, animated: true)
    }

    func back() {
        navigationController.popViewController(animated: true)
    }
}
