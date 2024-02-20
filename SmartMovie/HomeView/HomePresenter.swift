//  
//  HomePresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 07/04/2023.
//

import Foundation

final class HomePresenter {
    private weak var contentView: HomeContract.View?
    private var model: HomeContract.Model
    private let coordinator: HomeCoordinator
    private var titleCategories: [String] = [AppConstant.Title.movies]
    init(model: HomeContract.Model,
         view: HomeContract.View, coordinator: HomeCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension HomePresenter: HomePresenterProtocol {
    func appendTitle(title: String) {
        if titleCategories.contains(title) == false {
            titleCategories.append(title)
            contentView?.reloadData()
        } else {
            return
        }
    }

    func numberOfItemInSection() -> Int {
        return titleCategories.count
    }

    func getTitle() -> [String] {
        return titleCategories
    }

    func getIndexTitle(title: String) -> Int {
        return titleCategories.firstIndex(of: title) ?? 0
    }
}
