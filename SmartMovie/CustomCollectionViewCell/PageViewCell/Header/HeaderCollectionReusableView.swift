//
//  HeaderCollectionReusableView.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class HeaderCollectionReusableView: BaseHeaderCollectionView {
    // MARK: - Outlet
    @IBOutlet weak var titleTypeLabel: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func goToPage(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("goToPage"),
                                        object: nil,
                                        userInfo: ["title": titleTypeLabel.text ?? ""])
    }
}

extension HeaderCollectionReusableView {
    func setupHeaderUI(_ title: String) {
        titleTypeLabel.text = title
    }
}
