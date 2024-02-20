//
//  GenresCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import UIKit

final class GenresCell: BaseCollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var genresImageView: UIImageView!
    @IBOutlet weak var genresNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        genresNameLabel.font = UIFont(name: "Helvetica-Bold", size: 35)
        genresNameLabel.textColor = .white
        genresNameLabel.textAlignment = .center
    }
}

extension GenresCell {
    func setupCellUI(_ cellEntity: GenresViewEntity) {
        genresImageView.image = UIImage(named: "\(cellEntity.name ?? "placeholder")")
        genresNameLabel.text = cellEntity.name
    }
}
