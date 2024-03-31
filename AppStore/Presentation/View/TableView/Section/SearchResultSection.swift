//
//  SearchResultSection.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxDataSources

typealias AppInfoItems = [AppInfo]

struct SearchResultSection {

    typealias SearchResultSectionModel = SectionModel<Int, AppInfoItems>

    enum AppInfoItems: Equatable {
        case firstItem(AppInfo)
    }
}
