//
//  SceneDelegate.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let nav = UINavigationController()
        coordinator = AppCoordinator(nav)
        coordinator?.start()

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

