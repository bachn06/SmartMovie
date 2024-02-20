//
//  CastingCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import UIKit

final class CastingCell: BaseCollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension CastingCell {
    func setupCellUI(_ cellEntity: CastingDisplayModel) {
        nameLabel.text = cellEntity.name
        profileImageView.kf.setImage(with: URL(string: "\(ServerConstant.URLBase.imageURL)\(cellEntity.profilePath)"),
                                     placeholder: UIImage(named: "person"),
                                     options: [
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage
        ])
    }
}
