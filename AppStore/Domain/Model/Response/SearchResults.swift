//
//  SearchResults.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation

struct SearchResults: Codable {
    let resultCount: Int
    let results: [AppInfo]
}
