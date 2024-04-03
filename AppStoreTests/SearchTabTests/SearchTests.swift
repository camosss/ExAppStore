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

        let searchBarTermObservable = self.scheduler.createColdObservable([.next(10, "카카오")])

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObservable.asSignal(onErrorJustReturn: ""),
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

    func test_검색어_입력중에는_검색중_화면_리스트를_보여주는지() {

        let searchBarTermObservable = self.scheduler.createColdObservable([.next(10, "카카오")])

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObservable.asSignal(onErrorJustReturn: ""),
            recentTermDidTap: .never(),
            searchItemDidTap: .never(),
            shouldLoadResult: .never()
        )

        let searchResultViewTypeObserver = scheduler.createObserver([SearchResultViewType].self)
        let viewTypeSubject = PublishSubject<[SearchResultViewType]>()

        viewTypeSubject
            .bind(to: searchResultViewTypeObserver)
            .disposed(by: disposeBag)

        self.viewModel.transform(input: input)
            .sections
            .drive(onNext: { sections in
                let viewTypes = sections.map { $0.model }
                viewTypeSubject.onNext(viewTypes)
            })
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(searchResultViewTypeObserver.events, [
            .next(0, []),
            .next(10, [.searchingState])
        ], "검색어 입력중에는 검색 결과 섹션의 모델이 searchingState 상태여야 합니다.")
    }

    func test_최근_검색어_목록에서_특정_index의_Cell을_선택하면_검색_결과_화면을_보여주는지() {

        self.mockUseCase.mockRecentTerms = [
            RecentTermModel(id: "1", term: "카카오뱅크"),
            RecentTermModel(id: "2", term: "카카오페이")
        ]
        self.viewModel = SearchViewModel(coordinator: nil, useCase: mockUseCase)

        let viewDidLoadObservable = self.scheduler.createColdObservable([.next(0, ())])
        let recentTermDidTapObservable = self.scheduler.createColdObservable([.next(10, 1)])

        self.input = SearchViewModel.Input(
            viewDidLoad: viewDidLoadObservable.asObservable(),
            searchBarTerm: .never(),
            recentTermDidTap: recentTermDidTapObservable.asSignal(onErrorJustReturn: -1),
            searchItemDidTap: .never(),
            shouldLoadResult: .never()
        )

        let searchResultViewTypeObserver = scheduler.createObserver([SearchResultViewType].self)
        let viewTypeSubject = PublishSubject<[SearchResultViewType]>()

        viewTypeSubject
            .bind(to: searchResultViewTypeObserver)
            .disposed(by: disposeBag)

        self.viewModel.transform(input: input)
            .sections
            .drive(onNext: { sections in
                let viewTypes = sections.map { $0.model }
                viewTypeSubject.onNext(viewTypes)
            })
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(searchResultViewTypeObserver.events, [
            .next(0, []),
            .next(10, [.searchCompleted])
        ], "선택된 최근 검색어에 대한 검색 결과 섹션의 모델이 searchCompleted 상태여야 합니다.")
    }

    func test_검색어_입력중_화면에서_리스트의_특정_index의_Cell을_선택하면_검색_결과_화면을_보여주는지() {

        let searchBarTermObservable = self.scheduler.createColdObservable([.next(0, "카카오")])
        let searchItemDidTapObservable = self.scheduler.createColdObservable([.next(10, 1)])

        self.mockUseCase.mockAppInfos = [
            AppInfo(trackId: 2, trackName: "카카오페이"),
            AppInfo(trackId: 3, trackName: "카카오")
        ]
        self.viewModel = SearchViewModel(coordinator: nil, useCase: mockUseCase)

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObservable.asSignal(onErrorJustReturn: ""),
            recentTermDidTap: .never(),
            searchItemDidTap: searchItemDidTapObservable.asSignal(onErrorJustReturn: 0),
            shouldLoadResult: .never()
        )

        let searchResultViewTypeObserver = scheduler.createObserver([SearchResultViewType].self)
        let viewTypeSubject = PublishSubject<[SearchResultViewType]>()

        viewTypeSubject
            .bind(to: searchResultViewTypeObserver)
            .disposed(by: disposeBag)

        self.viewModel.transform(input: input)
            .sections
            .drive(onNext: { sections in
                let viewTypes = sections.map { $0.model }
                viewTypeSubject.onNext(viewTypes)
            })
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(searchResultViewTypeObserver.events, [
            .next(0, []),
            .next(0, [.searchingState]), // 검색어 입력중
            .next(10, [.searchCompleted])
        ], "검색어 입력중 화면에서 특정 index의 Cell을 선택하면 검색 결과 섹션의 모델이 searchCompleted 상태여야 합니다.")
    }

    func test_검색어_입력중_화면에서_키보드의_검색_버튼을_선택하면_검색_결과_화면을_보여주는지() {

        let searchBarTermObservable = self.scheduler.createColdObservable([.next(0, "카카오")])
        let shouldLoadResultObservable = self.scheduler.createColdObservable([.next(10, ())])

        self.input = SearchViewModel.Input(
            viewDidLoad: .never(),
            searchBarTerm: searchBarTermObservable.asSignal(onErrorJustReturn: ""),
            recentTermDidTap: .never(),
            searchItemDidTap: .never(),
            shouldLoadResult: shouldLoadResultObservable.asSignal(onErrorJustReturn: ())
        )

        let searchResultViewTypeObserver = scheduler.createObserver([SearchResultViewType].self)
        let viewTypeSubject = PublishSubject<[SearchResultViewType]>()

        viewTypeSubject
            .bind(to: searchResultViewTypeObserver)
            .disposed(by: disposeBag)

        self.viewModel.transform(input: input)
            .sections
            .drive(onNext: { sections in
                let viewTypes = sections.map { $0.model }
                viewTypeSubject.onNext(viewTypes)
            })
            .disposed(by: disposeBag)

        self.scheduler.start()

        XCTAssertEqual(searchResultViewTypeObserver.events, [
            .next(0, []),
            .next(0, [.searchingState]), // 검색어 입력중
            .next(10, [.searchCompleted])
        ], "검색어 입력중 화면에서 키보드의 검색 버튼을 선택하면 검색 결과 섹션의 모델이 searchCompleted 상태여야 합니다.")
    }
}
