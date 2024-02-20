//
//  GenresPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class GenresPresenter {
    private weak var contentView: GenresContract.View?
    private var model: GenresContract.Model
    private let coordinator: GenresCoordinator
    private var listGenre: [GenresViewEntity] = []

    init(model: GenresContract.Model,
         view: GenresContract.View,
         coordinator: GenresCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension GenresPresenter: GenresPresenterProtocol {
    func fetchGenreData() {
        model.getGenres { [weak self] result in
            switch result {
            case .success(let dataResponse):
                let listGenresViewEntity = dataResponse.map { genresResponseEntity in
                    GenresViewEntity(response: genresResponseEntity)
                }
                DispatchQueue.main.async {
                    self?.listGenre.append(contentsOf: listGenresViewEntity)
                    self?.contentView?.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.contentView?.displayError {
                        self?.fetchGenreData()
                    }
                }
            }
        }
    }

    func numberOfItemInSection() -> Int {
        return listGenre.count
    }

    func cellForItemAt(index: Int) -> GenresViewEntity {
        if listGenre.isEmpty == false {
            return listGenre[index]
        }
        return GenresViewEntity()
    }

    func didSelectItemAt(index: Int) {
        if listGenre.isEmpty == false {
            coordinator.getListGenreMovies(genre: listGenre[index])
        }
    }
}
