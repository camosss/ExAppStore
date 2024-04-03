//
//  SearchViewModel.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelType {

    struct Input {
        let viewDidLoad: Observable<Void>
        let searchBarTerm: Signal<String>
        let recentTermDidTap: Signal<Int>
        let searchItemDidTap: Signal<Int>
        let shouldLoadResult: Signal<Void>
    }
    struct Output {
        let isSearchBarActive: Driver<Bool>
        let currentTerm: Driver<String>
        let sections: Driver<[SearchResultSection.SearchResultSectionModel]>
        let appInfos: Driver<[AppInfo]>
        let recentTerms: Driver<[RecentTermModel]>
    }

    private weak var coordinator: SearchCoordinator?
    private let useCase: SearchUseCase
    var disposeBag = DisposeBag()

    private let isSearchBarActive = BehaviorRelay<Bool>(value: false)
    private let currentTerm = BehaviorRelay<String>(value: "")
    private let sections = BehaviorRelay<[SearchResultSection.SearchResultSectionModel]>(value: [])
    private let appInfos = BehaviorRelay<[AppInfo]>(value: [])
    private let recentTerms = BehaviorRelay<[RecentTermModel]>(value: [])

    // MARK: - Init

    init(
        coordinator: SearchCoordinator?,
        useCase: SearchUseCase
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                let recentTerms = self.useCase.getRecentTerms()
                self.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        input.searchBarTerm
            .emit(onNext: { [weak self] term in
                guard let self = self,
                      self.currentTerm.value != term
                else { return }

                self.isSearchBarActive.accept(true)
                self.currentTerm.accept(term)

                self.useCase.requestSearch(term: term)
            })
            .disposed(by: disposeBag)

        input.recentTermDidTap
            .asSignal()
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                let recentTerm = self.recentTerms.value[index]
                self.currentTerm.accept(recentTerm.term)

                self.isSearchBarActive.accept(false)
                self.useCase.requestSearch(term: recentTerm.term)

                self.addRecentTerm(
                    id: recentTerm.id,
                    term: recentTerm.term
                )
            })
            .disposed(by: disposeBag)

        input.searchItemDidTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                let appInfo = self.appInfos.value[index]

                if self.isSearchBarActive.value {
                    self.isSearchBarActive.accept(false)

                    if let trackId = appInfo.trackId,
                       let term = appInfo.trackName {

                        self.currentTerm.accept(term)
                        self.useCase.requestSearch(term: term)

                        self.addRecentTerm(id: String(trackId), term: term)
                    }

                } else {
                    self.coordinator?.showDetailAppInfoViewController(
                        appInfo: appInfo
                    )
                }
            })
            .disposed(by: disposeBag)

        input.shouldLoadResult
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.isSearchBarActive.accept(false)

                let currentTerm = self.currentTerm.value
                self.useCase.requestSearch(term: currentTerm)

                self.addRecentTerm(id: UUID().uuidString, term: currentTerm)
            })
            .disposed(by: disposeBag)

        useCase.searchResults
            .asSignal()
            .emit(onNext: { [weak self] searchResults in
                guard let self = self else { return }

                self.appInfos.accept(searchResults.results)

                let items = searchResults.results.map { result -> SearchResultSection.AppInfoItems in
                    let viewType: SearchResultViewType = self.isSearchBarActive.value ?
                        .searchingState : .searchCompleted

                    switch viewType {
                    case .searchingState:
                        return .searchingState(result)
                    case .searchCompleted:
                        return .searchCompleted(result)
                    }
                }

                let sectionModel = SearchResultSection.SearchResultSectionModel(
                    model: self.isSearchBarActive.value ? .searchingState : .searchCompleted,
                    items: items
                )

                self.sections.accept([sectionModel])
            })
            .disposed(by: disposeBag)

        return Output(
            isSearchBarActive: isSearchBarActive.asDriver(),
            currentTerm: currentTerm.asDriver(),
            sections: sections.asDriver(),
            appInfos: appInfos.asDriver(),
            recentTerms: recentTerms.asDriver()
        )
    }
}

extension SearchViewModel {
    private func addRecentTerm(id: String, term: String) {
        self.useCase.addRecentTerm(id: id, term: term)

        let recentTerms = self.useCase.getRecentTerms()
        self.recentTerms.accept(recentTerms)
    }
}
