//
//  SearchUseCase.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxCocoa

protocol SearchUseCase: AnyObject {

    var searchResults: PublishRelay<SearchResults> { get set }
    var failError: PublishRelay<Error> { get set }

    func requestSearch(term: String)
}
