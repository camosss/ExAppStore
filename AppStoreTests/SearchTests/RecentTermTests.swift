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
    private var viewModel: SearchViewModel!
    private var input: SearchViewModel.Input!
    private var output: SearchViewModel.Output!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
        scheduler = nil
        viewModel = nil
    }
}
