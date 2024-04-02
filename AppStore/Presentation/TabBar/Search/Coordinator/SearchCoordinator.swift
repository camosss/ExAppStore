//
//  SearchCoordinator.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

final class SearchCoordinator: NSObject, Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    func start() {
        let vc = SearchViewController(
            viewModel: SearchViewModel(
                coordinator: self,
                useCase: SearchUseCaseImpl(
                    searchRepository: SearchRepository(), 
                    recentTermRepository: RecentTermRepository()
                )
            )
        )

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }

    func showDetailAppInfoViewController(appInfo: AppInfo) {
        let vc = DetailAppInfoViewController(appInfo: appInfo)

        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension SearchCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        navigationController.navigationBar.prefersLargeTitles = viewController is SearchViewController
    }
}
