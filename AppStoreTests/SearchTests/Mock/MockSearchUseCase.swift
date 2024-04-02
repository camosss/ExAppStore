//
//  MockSearchUseCase.swift
//  AppStoreTests
//
//  Created by 강호성 on 4/2/24.
//

import Foundation

import RxCocoa
import RxSwift
@testable import AppStore

final class MockSearchUseCase: SearchUseCase {

    var searchResults = PublishRelay<SearchResults>()
    var failError = PublishRelay<Error>()

    func requestSearch(term: String) {

    }

    func getRecentTerms() -> [RecentTermModel] {
        return []
    }

    func addRecentTerm(id: String, term: String) {

    }
}
