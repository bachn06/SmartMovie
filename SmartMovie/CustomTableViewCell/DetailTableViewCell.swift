//
//  DetailTableViewCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 06/04/2023.
//

import UIKit

final class DetailTableViewCell: BaseTableViewCell {
    @IBOutlet weak var castingCollectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()
    private var listCasting: [CastingDisplayModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView(castingCollectionView)
    }
}

extension DetailTableViewCell {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.registerCell(type: CastingCell.self)
    }
    func setupCellUI(_ cellEntity: [CastingDisplayModel]) {
        listCasting = cellEntity
        castingCollectionView.reloadData()
    }
}

extension DetailTableViewCell: UICollectionViewDelegate {
}

extension DetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCasting.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castingCollectionView.dequeueCell(indexPath: indexPath) as CastingCell
        cell.layer.cornerRadius = 10
        if listCasting.isEmpty == false {
            cell.setupCellUI(listCasting[indexPath.row])
        }
        return cell
    }
}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: castingCollectionView.bounds.width / 3.5, height: 140)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
