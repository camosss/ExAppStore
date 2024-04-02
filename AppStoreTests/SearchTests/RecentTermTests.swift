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

extension RecentTermTests {
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

    func test_검색어_입력중_화면에서_리스트의_특정_Cell을_선택하면_최근_검색어_목록에_저장되는지() {

        let expectedRecentTerms = [
            RecentTermModel(id: "1", term: "카카오뱅크"),
            RecentTermModel(id: "3", term: "카카오")
        ]

        self.mockUseCase.mockRecentTerms = [RecentTermModel(id: "1", term: "카카오뱅크")]
        self.mockUseCase.mockAppInfos = [
            AppInfo(trackId: 2, trackName: "카카오페이"),
            AppInfo(trackId: 3, trackName: "카카오")
        ]
        self.viewModel = SearchViewModel(coordinator: nil, useCase: mockUseCase)

        let searchBarTermObserver = self.scheduler.createColdObservable([.next(0, "카카오")])

        // mockAppInfos의 1번 index인 AppInfo(trackId: 3, trackName: "카카오")를 선택
        let searchItemDidTapObserver = self.scheduler.createColdObservable([.next(10, 1)])

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObserver.asSignal(onErrorJustReturn: ""),
            recentTermDidTap: .never(),
            searchItemDidTap: searchItemDidTapObserver.asSignal(onErrorJustReturn: 0),
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
