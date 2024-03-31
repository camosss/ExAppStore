//
//  SearchUseCaseImpl.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxCocoa

final class SearchUseCaseImpl: SearchUseCase {

    private let searchRepository: SearchRepositoryType

    var searchResults = PublishRelay<SearchResults>()
    var failError = PublishRelay<Error>()

    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
    }
}

extension SearchUseCaseImpl {
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
}
