//  
//  ArtistsContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 09/04/2023.
//

import Foundation

protocol ArtistsContract {
    typealias Model = ArtistsModelProtocol
    typealias View = ArtistsViewProtocol
    typealias Presenter = ArtistsPresenterProtocol
}

protocol ArtistsModelProtocol {
}

protocol ArtistsViewProtocol: AnyObject {
    func set(presenter: ArtistsPresenterProtocol)
}

protocol ArtistsPresenterProtocol {
}
