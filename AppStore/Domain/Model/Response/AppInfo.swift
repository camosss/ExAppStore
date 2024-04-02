//
//  AppInfo.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation

struct AppInfo: Codable {
    let artistId: Int?
    let artistName: String?
    let artworkUrl512: String?
    let trackId: Int?
    let trackName: String?
    let trackViewUrl: String?
    let sellerName: String?
    let description: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let screenshotUrls: [String]?
    let releaseNotes: String?

    init(
        artistId: Int? = nil,
        artistName: String? = nil ,
        artworkUrl512: String? = nil,
        trackId: Int? = nil,
        trackName: String? = nil,
        trackViewUrl: String? = nil,
        sellerName: String? = nil,
        description: String? = nil,
        averageUserRating: Double? = nil,
        userRatingCount: Int? = nil,
        screenshotUrls: [String]? = nil,
        releaseNotes: String? = nil
    ) {
        self.artistId = artistId
        self.artistName = artistName
        self.artworkUrl512 = artworkUrl512
        self.trackId = trackId
        self.trackName = trackName
        self.trackViewUrl = trackViewUrl
        self.sellerName = sellerName
        self.description = description
        self.averageUserRating = averageUserRating
        self.userRatingCount = userRatingCount
        self.screenshotUrls = screenshotUrls
        self.releaseNotes = releaseNotes
    }
}

extension AppInfo: Equatable {
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
