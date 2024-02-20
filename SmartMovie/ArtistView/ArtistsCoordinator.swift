//
//  ArtistsCoordinator.swift
//  HondaConnect
//
//  Created by BachNguyen on 23/05/2022.
//

import Foundation
import UIKit

final class ArtistsCoordinator: BaseCoordinator {

}

extension ArtistsCoordinator {
    func startArtists(data: Any? = nil) -> ArtistsViewController {
        let scene = UIStoryboard(name: "Artists", bundle: nil).instantiate(ArtistsViewController.self)
        let presenter = ArtistsPresenter(model: ArtistsModel(),
                                         view: scene,
                                         coordinator: self)
        scene.set(presenter: presenter)
        return scene
    }

    func start(data: Any? = nil) {
        let scene = UIStoryboard(name: "Artists", bundle: nil).instantiate(ArtistsViewController.self)
        let presenter = ArtistsPresenter(model: ArtistsModel(),
                                                            view: scene,
                                                            coordinator: self)
        scene.set(presenter: presenter)
        navigationController.pushViewController(scene, animated: true)
    }
    func back() {
        navigationController.popViewController(animated: true)
    }
}
