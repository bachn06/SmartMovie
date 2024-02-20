//
//  UITableViewExtension.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import UIKit

extension UITableView {
    func registerCell< T: NibLoadable>(type: T.Type) {
        register(T.getNib(), forCellReuseIdentifier: T.getNibName())
    }

    func dequeueCell< T: NibLoadable>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.getNibName(), for: indexPath) as? T else {
            fatalError("couldnt dequeue cell with identifier \(T.getNibName())")
        }
        return cell
    }
}
