//
//  GridMovieCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit
import Kingfisher

final class GridMovieCell: BaseCollectionViewCell {
    // MARK: - Outlet
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    private var movieID: Int32 = 0
    private var isFavourite: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addFavoriteButton(_ sender: Any) {
        if isFavourite {
            DBManager.shared.deleteFavourite(idMovie: movieID)
            favouriteButton.setImage(UIImage(named: "star"), for: .normal)
        } else {
            DBManager.shared.addFavourite(idMovie: movieID)
            favouriteButton.setImage(UIImage(named: "star.fill"), for: .normal)
        }
        isFavourite = !isFavourite
    }
}

extension GridMovieCell {
    func setupCellUI(_ cellEntity: MovieDisplayModel) {
        movieID = Int32(cellEntity.id)
        let favouriteMovie = DBManager.shared.getFavourite(idMovie: movieID)
        if favouriteMovie == true {
            favouriteButton.setImage(UIImage(named: "star.fill"), for: .normal)
            isFavourite = true
        } else {
            favouriteButton.setImage(UIImage(named: "star"), for: .normal)
            isFavourite = false
        }
        movieImageView.kf.setImage(with: URL(string: "\(ServerConstant.URLBase.imageURL)\(cellEntity.posterPath)"),
                                   placeholder: UIImage(named: "placeholder"),
                                   options: [
                                    .transition(.fade(0.3)),
                                    .cacheOriginalImage
        ])
        movieTitleLabel.text = cellEntity.title
        durationLabel.text = cellEntity.duration
    }
}
