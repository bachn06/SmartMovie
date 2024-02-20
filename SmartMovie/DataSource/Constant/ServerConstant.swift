//
//  ServerConstant.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import Foundation

struct ServerConstant {
    struct URLBase {
        static var baseURL: String = "https://api.themoviedb.org/3/"
        static var imageURL: String = "https://image.tmdb.org/t/p/w300"
    }
    struct APIKey {
        static let apiKey: String = "?api_key=d5b97a6fad46348136d87b78895a0c06"
    }
}
