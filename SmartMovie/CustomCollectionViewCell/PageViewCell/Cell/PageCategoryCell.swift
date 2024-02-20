//
//  PageCategoryCell.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class PageCategoryCell: BaseCollectionViewCell {
    // MARK: - Outlet
    @IBOutlet var titlePageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(with title: String) {
        titlePageLabel.text = title
    }

}
