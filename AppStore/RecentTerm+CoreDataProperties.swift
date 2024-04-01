//
//  RecentTerm+CoreDataProperties.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//
//

import Foundation
import CoreData


extension RecentTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentTerm> {
        return NSFetchRequest<RecentTerm>(entityName: "RecentTerm")
    }

    @NSManaged public var id: Int32
    @NSManaged public var term: String?
    @NSManaged public var createdAt: Date?

}

extension RecentTerm : Identifiable {

}
