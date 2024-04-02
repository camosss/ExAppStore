//
//  SearchTests.swift
//  AppStoreTests
//
//  Created by 강호성 on 4/3/24.
//

import XCTest
import RxTest
import RxCocoa
import RxSwift
@testable import AppStore

final class SearchTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    private var mockUseCase: MockSearchUseCase!
    private var viewModel: SearchViewModel!
    private var input: SearchViewModel.Input!
    private var output: SearchViewModel.Output!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)

        mockUseCase = MockSearchUseCase()
        viewModel = SearchViewModel(
            coordinator: nil,
            useCase: mockUseCase
        )
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
        scheduler = nil

        mockUseCase = nil
        viewModel = nil
    }
}

extension SearchTests {
    func test_검색어_입력하면_검색_결과를_반환하는지() {

        let expectedAppInfos = [
            AppInfo(trackId: 1, trackName: "카카오"),
            AppInfo(trackId: 2, trackName: "카카오페이"),
            AppInfo(trackId: 3, trackName: "카카오뱅크")
        ]

        self.mockUseCase.mockAppInfos = [
            AppInfo(trackId: 1, trackName: "카카오"),
            AppInfo(trackId: 2, trackName: "카카오페이"),
            AppInfo(trackId: 3, trackName: "카카오뱅크")
        ]
        self.viewModel = SearchViewModel(coordinator: nil, useCase: mockUseCase)

        let searchBarTermObserver = self.scheduler.createColdObservable([.next(10, "카카오")])

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObserver.asSignal(onErrorJustReturn: ""),
            recentTermDidTap: .never(),
            searchItemDidTap: .never(),
            shouldLoadResult: .never()
        )

        let appInfosObserver = self.scheduler.createObserver([AppInfo].self)

        self.viewModel.transform(input: input)
            .appInfos
            .drive(appInfosObserver)
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(
            appInfosObserver.events,
            [.next(0, []),
             .next(10, expectedAppInfos)]
        )
    }
}
