//
//  AppCoordinator.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Properties

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    // MARK: - Init

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Helpers

    func start() {
        connectTabBar()
    }

    private func connectTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.delegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}

// MARK: - CoordinatorDelegate
extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        finish()
    }
}
