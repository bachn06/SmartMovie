//
//  UICollectionViewExtension.swift
//  SmartMovie
//
//  Created by BachNguyen on 30/03/2023.
//

import UIKit

extension UICollectionView {
    func registerHeader< T: NibLoadable>(type: T.Type) {
        register(T.getNib(),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.getNibName())
    }

    func dequeueHeader< T: NibLoadable>(indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                            withReuseIdentifier: T.getNibName(),
                                                            for: indexPath) as? T else {
            fatalError("couldnt dequeue header with identifier \(T.getNibName())")
        }
        return header
    }

    func registerCell< T: NibLoadable>(type: T.Type) {
        register(T.getNib(), forCellWithReuseIdentifier: T.getNibName())
    }

    func dequeueCell< T: NibLoadable>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.getNibName(), for: indexPath) as? T else {
            fatalError("couldnt dequeue cell with identifier \(T.getNibName())")
        }
        return cell
    }
}
