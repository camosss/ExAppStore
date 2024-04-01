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
}

extension AppInfo: Equatable {
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
