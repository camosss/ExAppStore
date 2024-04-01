//
//  RecentTermStore.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import Foundation
import CoreData

protocol RecentTermModelStore {
    var id: String { get }
    var term: String { get }
}

protocol RecentTermStore {
    func add(id: String, term: String)
    func getRecentTerms() -> [RecentTermModel]
    func remove(id: String, term: String)
    func removeAll()
    func removeLast()
    func count() -> Int?
}
