//
//  SearchRquest.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation

struct SearchRquest {
    let term: String
    let country: String
    let media: String?
    let limit: Int?

    init(
        term: String,
        country: String,
        media: String? = "software",
        limit: Int? = 10
    ) {
        self.term = term
        self.country = country
        self.media = media
        self.limit = limit
    }

    var toDictionary: [String: Any] {
        var dictionary: [String: Any] = [
            "term": term,
            "country": country
        ]
        if let limit = limit {
            dictionary["limit"] = limit
        }
        if let media = media {
            dictionary["media"] = media
        }
        return dictionary
    }
}
