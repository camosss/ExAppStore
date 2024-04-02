//
//  DefaultSearchUseCase.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxCocoa

final class DefaultSearchUseCase: SearchUseCase {

    private let searchRepository: SearchRepositoryType
    private let recentTermRepository: RecentTermStore

    var searchResults = PublishRelay<SearchResults>()
    var failError = PublishRelay<Error>()

    init(
        searchRepository: SearchRepositoryType,
        recentTermRepository: RecentTermStore
    ) {
        self.searchRepository = searchRepository
        self.recentTermRepository = recentTermRepository
    }
}

extension DefaultSearchUseCase {
    func requestSearch(term: String) {
        searchRepository.requestSearch(
            request: SearchRquest(term: term)
        ) { [weak self] response in
            guard let self = self else { return }

            switch response {
            case .success(let value):
                self.searchResults.accept(value)

            case .failure(let error):
                self.failError.accept(error)
            }
        }
    }

    func getRecentTerms() -> [RecentTermModel] {
        let recentTerms = recentTermRepository.getRecentTerms()
        return recentTerms
    }

    func addRecentTerm(id: String, term: String) {
        recentTermRepository.add(id: id, term: term)
    }
}
