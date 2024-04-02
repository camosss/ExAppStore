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
        let isEditingSearchBar: Driver<Bool>
        let currentTerm: Driver<String>
        let sections: Driver<[SearchResultSection.SearchResultSectionModel]>
        let appInfos: Driver<[AppInfo]>
        let recentTerms: Driver<[RecentTermModel]>
    }

    private weak var coordinator: SearchCoordinator?
    private let useCase: SearchUseCase
    var disposeBag = DisposeBag()

    private let isEditingSearchBar = BehaviorRelay<Bool>(value: false)
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

                self.isEditingSearchBar.accept(true)
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

                self.isEditingSearchBar.accept(false)
                self.useCase.requestSearch(term: recentTerm.term)

                self.useCase.addRecentTerm(
                    id: recentTerm.id,
                    term: recentTerm.term
                )

                let recentTerms = self.useCase.getRecentTerms()
                self.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        input.searchItemDidTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                let appInfo = self.appInfos.value[index]

                if let trackId = appInfo.trackId,
                   let term = appInfo.trackName {
                    let id = String(trackId)

                    self.useCase.addRecentTerm(id: id, term: term)

                    let recentTerms = self.useCase.getRecentTerms()
                    self.recentTerms.accept(recentTerms)
                }

                if self.isEditingSearchBar.value {
                    self.isEditingSearchBar.accept(false)

                    if let trackName = appInfo.trackName {
                        self.currentTerm.accept(trackName)
                        self.useCase.requestSearch(term: trackName)
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

                self.isEditingSearchBar.accept(false)

                let currentTerm = self.currentTerm.value
                self.useCase.requestSearch(term: currentTerm)

                self.useCase.addRecentTerm(
                    id: UUID().uuidString,
                    term: currentTerm
                )

                let recentTerms = self.useCase.getRecentTerms()
                self.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        useCase.searchResults
            .asSignal()
            .emit(onNext: { [weak self] searchResults in
                guard let self = self else { return }

                self.appInfos.accept(searchResults.results)

                var section: [SearchResultSection.SearchResultSectionModel]

                if self.isEditingSearchBar.value {
                    section = [.init(
                        model: .searchingState,
                        items: searchResults.results.map { .searchingState($0) }
                    )]

                } else {
                    section = [.init(
                        model: .searchCompleted,
                        items: searchResults.results.map { .searchCompleted($0) }
                    )]
                }

                self.sections.accept(section)
            })
            .disposed(by: disposeBag)

        return Output(
            isEditingSearchBar: isEditingSearchBar.asDriver(),
            currentTerm: currentTerm.asDriver(),
            sections: sections.asDriver(),
            appInfos: appInfos.asDriver(),
            recentTerms: recentTerms.asDriver()
        )
    }
}
