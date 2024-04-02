//
//  RecentTermModel.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import Foundation

struct RecentTermModel: RecentTermModelStore {
    var id: String
    var term: String

    init(id: String, term: String) {
        self.id = id
        self.term = term
    }
}

extension RecentTermModel: Equatable {
    static func == (lhs: RecentTermModel, rhs: RecentTermModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.term == rhs.term
    }
}
