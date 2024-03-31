//
//  SearchResultSection.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxDataSources

enum SearchResultViewType: Int {
    case searchingState
    case searchCompleted
}

typealias AppInfoItems = [AppInfo]

struct SearchResultSection {

    typealias SearchResultSectionModel = SectionModel<SearchResultViewType, AppInfoItems>

    enum AppInfoItems: Equatable {
        case searchingState(AppInfo)
        case searchCompleted(AppInfo)
    }
}
