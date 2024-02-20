//
//  SearchTableViewCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 01/04/2023.
//

import UIKit
import Kingfisher

final class SearchTableViewCell: BaseTableViewCell {
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var categoriesMovieLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var footerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backdropImageView.layer.cornerRadius = 10
        footerImage.layer.cornerRadius = 10
        categoriesMovieLabel.textColor = .lightGray
    }
}

extension SearchTableViewCell {
    func setupCellUI(_ cellEntity: MovieDisplayModel) {
        backdropImageView.kf.setImage(with: URL(string: "\(ServerConstant.URLBase.imageURL)\(cellEntity.backdropPath)"),
                                      placeholder: UIImage(named: "placeholder"),
                                      options: [
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage
        ])
        titleMovieLabel.text = cellEntity.title
        categoriesMovieLabel.text = cellEntity.genres.map({ $0.name ?? "" }).joined(separator: " | ")
        setStar(cellEntity.voteAverage, ratingStackView)
    }
}
