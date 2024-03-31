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
    let artistViewUrl: String?
    let artworkUrl512: String?
    let sellerName: String?
    let sellerUrl: String?
    let trackId: Int?
    let trackName: String?
    let trackCensoredName: String?
    let trackViewUrl: String?
    let trackContentRating: String?
    let description: String?
    let contentAdvisoryRating: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let screenshotUrls: [String]?
    let version: String?
    let minimumOsVersion: String?
    let currentVersionReleaseDate: String?
    let releaseNotes: String?
    let releaseDate: String?
    let genreIds: [String]?
    let genres: [String]?
    let primaryGenreId: Int?
    let primaryGenreName: String?
    let bundleID: String?
    let isVppDeviceBasedLicensingEnabled: Bool
    let languageCodesISO2A: [String]?
    let formattedPrice: String?
}

extension AppInfo: Equatable {
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.trackId == rhs.trackId
    }
}
