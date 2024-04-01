//
//  RecentTermRepository.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import Foundation
import CoreData

final class RecentTermModel: RecentTermModelStore {
    var id: String = ""
    var term: String = ""

    init(id: String, term: String) {
        self.id = id
        self.term = term
    }
}

final class RecentTermRepository: RecentTermStore {

    // MARK: - Properties

    let coreDataStack: CoreDataStack
    let maxCount: Int

    // MARK: - Init

    init(
        coreDataStack: CoreDataStack = CoreDataStack.shared,
        maxCount: Int = 10
    ) {
        self.coreDataStack = coreDataStack
        self.maxCount = maxCount
    }

    // MARK: - Helpers

    func add(id: String, term: String) {
        let context = coreDataStack.taskContext()

        if let count = count(), count == maxCount {
            removeLast()
        }

        if let savedRecentTerm = fetch(id, term, in: context) {
            savedRecentTerm.createdAt = Date()

        } else {
            create(id, term, in: context)
        }

        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("add RecentTerm error: \(error)")
            }
        }
    }

    func getRecentTerms() -> [RecentTermModel] {
        return fetchAll().map {
            return RecentTermModel(id: $0.id ?? "", term: $0.term ?? "")
        }
    }

    func remove(id: String, term: String) {
        let context = coreDataStack.taskContext()

        let fetchRequest: NSFetchRequest<RecentTerm> = RecentTerm.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "(id.length > 0 AND id == %@) OR (term == %@)",
            argumentArray: [id, term]
        )

        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()

        } catch _ {
            print("remove RecentTerm error")
        }
    }

    func removeAll() {
        let context = coreDataStack.taskContext()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: RecentTerm.fetchRequest())

        do {
            try context.execute(deleteRequest)
            try context.save()

        } catch {
            print("removeAll RecentTerm error: \(error)")
        }
    }

    func removeLast() {
        guard let removeTarget = fetchAll().last,
              let id = removeTarget.id,
              let term = removeTarget.term
        else { return }

        remove(id: id, term: term)
    }

    func count() -> Int? {
        let context = coreDataStack.taskContext()
        let fetchRequest: NSFetchRequest<RecentTerm> = RecentTerm.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            return count

        } catch {
            return nil
        }
    }

    fileprivate func create(
        _ id: String,
        _ term: String,
        in context: NSManagedObjectContext
    ) {
        let recentTerm = RecentTerm(context: context)
        recentTerm.id = id
        recentTerm.term = term
        recentTerm.createdAt = Date()
    }

    fileprivate func fetch(
        _ id: String,
        _ term: String,
        in context: NSManagedObjectContext
    ) -> RecentTerm? {

        let fetchRequest: NSFetchRequest<RecentTerm> = RecentTerm.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "(id.length > 0 AND id == %@) OR (term == %@)",
            argumentArray: [id, term]
        )

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }

    fileprivate func fetchAll() -> [RecentTerm] {
        let fetchRequest: NSFetchRequest<RecentTerm> = RecentTerm.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            return try coreDataStack.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
