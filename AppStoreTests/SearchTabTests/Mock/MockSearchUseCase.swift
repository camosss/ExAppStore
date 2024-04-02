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

    var mockRecentTerms: [RecentTermModel] = []
    var mockAppInfos: [AppInfo] = []

    func requestSearch(term: String) {
        searchResults.accept(
            SearchResults(
                resultCount: mockAppInfos.count,
                results: mockAppInfos
            )
        )
    }

    func getRecentTerms() -> [RecentTermModel] {
        return mockRecentTerms
    }

    func addRecentTerm(id: String, term: String) {
        mockRecentTerms.append(RecentTermModel(id: id, term: term))
    }
}
