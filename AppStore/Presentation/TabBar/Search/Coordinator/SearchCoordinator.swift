//
//  SearchCoordinator.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

final class SearchCoordinator: Coordinator {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        let vc = SearchViewController(
            viewModel: SearchViewModel(
                coordinator: self,
                useCase: SearchUseCaseImpl(
                    searchRepository: SearchRepository()
                )
            )
        )

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }

    func showDetailAppInfoViewController(appInfo: AppInfo) {
        let vc = DetailAppInfoViewController(appInfo: appInfo)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: true)
    }
}
