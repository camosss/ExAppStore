//
//  TabBarItem.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import Foundation

enum TabBarItem: Int, CaseIterable {
    case today
    case game
    case app
    case arcade
    case search

    var title: String {
        switch self {
        case .today:
            return "투데이"
        case .game:
            return "게임"
        case .app:
            return "앱"
        case .arcade:
            return "Arcade"
        case .search:
            return "검색"
        }
    }

    func deselectedIconName() -> String {
        switch self {
        case .today:
            return "doc.text.image"
        case .game:
            return "paperplane"
        case .app:
            return "square.stack.3d.up"
        case .arcade:
            return "arcade.stick.console"
        case .search:
            return "magnifyingglass"
        }
    }

    func selectedIconName() -> String {
        switch self {
        case .today:
            return "doc.text.image.fill"
        case .game:
            return "paperplane.fill"
        case .app:
            return "square.stack.3d.up.fill"
        case .arcade:
            return "arcade.stick.console.fill"
        case .search:
            return "magnifyingglass"
        }
    }
}
