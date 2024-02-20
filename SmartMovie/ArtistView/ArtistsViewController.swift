//
//  ArtistsViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class ArtistsViewController: UIViewController {
    private var presenter: ArtistsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ArtistsViewController: ArtistsViewProtocol {
    func set(presenter: ArtistsPresenterProtocol) {
        self.presenter = presenter
    }
}
