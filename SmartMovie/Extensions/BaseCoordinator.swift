//
//  BaseCoordinator.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start(data: Any?)
}

class BaseCoordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController, parent: Coordinator? = nil) {
        self.navigationController = navigationController
    }
}
