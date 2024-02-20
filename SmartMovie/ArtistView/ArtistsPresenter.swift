//  
//  ArtistsPresenter.swift
//  SmartMovie
//
//  Created by BachNguyen on 09/04/2023.
//

import Foundation

final class ArtistsPresenter {
    private weak var contentView: ArtistsContract.View?
    private var model: ArtistsContract.Model
    private let coordinator: ArtistsCoordinator
    init(model: ArtistsContract.Model,
         view: ArtistsContract.View, coordinator: ArtistsCoordinator) {
        self.model = model
        self.contentView = view
        self.coordinator = coordinator
    }
}

extension ArtistsPresenter: ArtistsPresenterProtocol {

}
