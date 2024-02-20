//
//  DetailCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {

}

extension DetailCoordinator: Coordinator {
    func start(data: Any? = nil) {
        guard let data = data as? MovieDisplayModel else { return }
        let scene = UIStoryboard(name: "Detail", bundle: nil).instantiate(DetailViewController.self)
        let presenter = DetailPresenter(model: DetailModel(),
                                             view: scene,
                                             coordinator: self)
        scene.set(presenter: presenter)
        DispatchQueue.main.async {
            self.navigationController.isNavigationBarHidden = true
        }
        presenter.fetchData(movieId: data.id) {
            presenter.setData()
        }
        navigationController.pushViewController(scene, animated: true)
    }
    func back() {
        DispatchQueue.main.async {
            self.navigationController.isNavigationBarHidden = false
        }
        navigationController.popViewController(animated: true)
    }
}
