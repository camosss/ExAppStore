//
//  RecentTermStore.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import Foundation
import CoreData

public protocol RecentTermModelStore {
    var id: Int32 { get }
    var term: String { get }
}

public protocol RecentTermStore {
    func add(id: Int32, term: String)
    func remove(id: Int32, term: String)
    func removeAll()
    func count() -> Int?
    func removeLast()
}
