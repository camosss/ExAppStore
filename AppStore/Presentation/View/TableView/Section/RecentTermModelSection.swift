//
//  RecentTermModelSection.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import Foundation
import RxDataSources

typealias RecentTermModelItems = [RecentTermModel]

struct RecentTermModelSection {

    typealias RecentTermModelSectionModel = SectionModel<Int, RecentTermModelItems>

    enum RecentTermModelItems: Equatable {
        case firstItem(RecentTermModel)
    }
}
