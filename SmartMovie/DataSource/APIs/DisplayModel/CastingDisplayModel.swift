//
//  CastingDisplayModel.swift
//  SmartMovie
//
//  Created by BachNguyen on 07/04/2023.
//

import Foundation

struct CastingDisplayModel {
    let name: String
    let profilePath: String
    init(response: CreditResponseEntity) {
        self.name = response.name ?? response.originalName ?? ""
        self.profilePath = response.profilePath ?? ""
    }
}
