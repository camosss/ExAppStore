//
//  SearchTarget.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import Moya

typealias DictionaryType = [String: Any]

enum SearchTarget {
    case search(parameters: DictionaryType)
}

extension SearchTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com/") else {
            fatalError("fatalError: INVALID API URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .search:
            return "search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .search(let parameters):
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
