//  
//  HomeContract.swift
//  SmartMovie
//
//  Created by BachNguyen on 07/04/2023.
//

import Foundation

protocol HomeContract {
    typealias Model = HomeModelProtocol
    typealias View = HomeViewProtocol
    typealias Presenter = HomePresenterProtocol
}

protocol HomeModelProtocol {
}

protocol HomeViewProtocol: AnyObject {
    func set(presenter: HomePresenterProtocol)
    func reloadData()
}

protocol HomePresenterProtocol {
    func numberOfItemInSection() -> Int
    func getTitle() -> [String]
    func getIndexTitle(title: String) -> Int
    func appendTitle(title: String)
}
