//
//  UIStoryboardExtension.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import UIKit

extension UIStoryboard {
    func instantiate<T: UIViewController>(_: T.Type) -> T {
        let identifier = String(describing: T.self)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Could not instantiate view controller with identifier \(identifier)")
        }
        return viewController
    }
}
