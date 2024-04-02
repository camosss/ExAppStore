//
//  RecentTermTests.swift
//  AppStoreTests
//
//  Created by 강호성 on 4/2/24.
//

import XCTest
import RxTest
import RxCocoa
import RxSwift
@testable import AppStore

final class RecentTermTests: XCTestCase {

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
            useCase: MockSearchUseCase()
        )
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
        scheduler = nil

        mockUseCase = nil
        viewModel = nil
    }

    func test_viewDidLoad_시점에_저장된_최근_검색어_목록을_가져오는지() {

        let expectedRecentTerms = [RecentTermModel(id: "1", term: "카카오뱅크")]

        self.mockUseCase.mockRecentTerms = [RecentTermModel(id: "1", term: "카카오뱅크")]
        self.viewModel = SearchViewModel(coordinator: nil, useCase: mockUseCase)

        let viewDidLoadTrigger = self.scheduler.createColdObservable([.next(10, ())])

        self.input = SearchViewModel.Input(
            viewDidLoad: viewDidLoadTrigger.asObservable(),
            searchBarTerm: .never(),
            recentTermDidTap: .never(),
            searchItemDidTap: .never(),
            shouldLoadResult: .never()
        )

        let recentTermsObserver = self.scheduler.createObserver([RecentTermModel].self)

        self.viewModel.transform(input: input)
            .recentTerms
            .drive(recentTermsObserver)
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(
            recentTermsObserver.events,
            [.next(0, []),
             .next(10, expectedRecentTerms)]
        )
    }
}
