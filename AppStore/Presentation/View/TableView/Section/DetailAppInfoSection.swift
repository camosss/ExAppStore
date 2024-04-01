//
//  DetailAppInfoSection.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import Foundation
import RxDataSources

enum DetailAppInfoViewType: Int {
    case screenshot
    case description
}

struct DetailAppInfoSection {

    typealias DetailAppInfoSectionModel = SectionModel<DetailAppInfoViewType, DetailAppInfoItems>

    enum DetailAppInfoItems: Equatable {
        case screenshot(AppInfo)
        case description(AppInfo)
    }
}
