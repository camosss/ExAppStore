//
//  SearchRepository.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import Moya

final class SearchRepository: SearchRepositoryType {
    let provider: MoyaProvider<SearchTarget>
    init() { provider = MoyaProvider<SearchTarget>() }
}

extension SearchRepository {
    func requestSearch(
        request: SearchRquest,
        completion: @escaping (Result<SearchResults, Error>) -> Void
    ) {
        provider.request(.search(parameters: request.toDictionary)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(SearchResults.self)
                    completion(.success(data))
                } catch {
                    dump(response)
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
