//
//  SearchRepositoryType.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation

protocol SearchRepositoryType: AnyObject {
    func requestSearch(
        request: SearchRquest,
        completion: @escaping (Result<SearchResults, Error>) -> Void
    )
}
