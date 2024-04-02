//
//  TabBarCoordinator.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    // MARK: - Properties

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    // MARK: - Init

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.tabBarController = UITabBarController()
    }

    // MARK: - Helpers

    func start() {
        let tabBarItems = TabBarItem.allCases
        let controllers: [UINavigationController] = tabBarItems.map {
            self.createTabNavigationController(of: $0)
        }
        configureTabBarController(with: controllers)
    }

    private func createTabNavigationController(of tabBar: TabBarItem) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = configureTabBarItem(of: tabBar)

        connectTabCoordinator(of: tabBar, to: tabNavigationController)
        return tabNavigationController
    }

    private func connectTabCoordinator(
        of tabBar: TabBarItem,
        to tabNavigationController: UINavigationController
    ) {
        switch tabBar {
        case .search:
            let searchCoordinator = SearchCoordinator(tabNavigationController)
            searchCoordinator.delegate = self
            self.childCoordinators.append(searchCoordinator)
            searchCoordinator.start()

        default:
            break
        }
    }

    private func configureTabBarController(with tabViewController: [UIViewController]) {
        tabBarController.setViewControllers(tabViewController, animated: false)
        tabBarController.selectedIndex = TabBarItem.search.rawValue
        tabBarController.view.backgroundColor = .systemBackground
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.unselectedItemTintColor = .lightGray

        navigationController.viewControllers = [tabBarController]
    }

    private func configureTabBarItem(of tabBar: TabBarItem) -> UITabBarItem {
        let tabBarItem = UITabBarItem(
            title: tabBar.title,
            image: UIImage(systemName: tabBar.deselectedIconName()),
            tag: tabBar.rawValue
        )
        tabBarItem.selectedImage = UIImage(systemName: tabBar.selectedIconName())
        return tabBarItem
    }
}

// MARK: - CoordinatorDelegate
extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        delegate?.didFinish(childCoordinator: self)
    }
}
