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
        let isEditingSearchBar = BehaviorRelay<Bool>(value: false)
        let currentTerm = BehaviorRelay<String>(value: "")
        let sections = BehaviorRelay<[SearchResultSection.SearchResultSectionModel]>(value: [])
        let appInfos = BehaviorRelay<[AppInfo]>(value: [])
        let recentTerms = BehaviorRelay<[RecentTermModel]>(value: [])
    }

    private weak var coordinator: SearchCoordinator?
    private let useCase: SearchUseCase
    var disposeBag = DisposeBag()

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
        let output = Output()

        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                let recentTerms = self.useCase.getRecentTerms()
                output.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        input.searchBarTerm
            .emit(onNext: { [weak self] term in
                guard let self = self,
                      output.currentTerm.value != term
                else { return }

                output.isEditingSearchBar.accept(true)
                output.currentTerm.accept(term)

                self.useCase.requestSearch(term: term)
            })
            .disposed(by: disposeBag)

        input.recentTermDidTap
            .asSignal()
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                let recentTerm = output.recentTerms.value[index]
                output.currentTerm.accept(recentTerm.term)

                output.isEditingSearchBar.accept(false)
                self.useCase.requestSearch(term: recentTerm.term)

                self.useCase.addRecentTerm(
                    id: recentTerm.id,
                    term: recentTerm.term
                )

                let recentTerms = self.useCase.getRecentTerms()
                output.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        input.searchItemDidTap
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                let appInfo = output.appInfos.value[index]
                
                if let trackId = appInfo.trackId,
                   let term = appInfo.trackName {
                    let id = String(trackId)

                    self.useCase.addRecentTerm(id: id, term: term)

                    let recentTerms = self.useCase.getRecentTerms()
                    output.recentTerms.accept(recentTerms)
                }

                if output.isEditingSearchBar.value {
                    output.isEditingSearchBar.accept(false)

                    if let trackName = appInfo.trackName {
                        output.currentTerm.accept(trackName)
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
                output.isEditingSearchBar.accept(false)

                let currentTerm = output.currentTerm.value
                self.useCase.requestSearch(term: currentTerm)

                self.useCase.addRecentTerm(
                    id: UUID().uuidString,
                    term: currentTerm
                )

                let recentTerms = self.useCase.getRecentTerms()
                output.recentTerms.accept(recentTerms)
            })
            .disposed(by: disposeBag)

        useCase.searchResults
            .asSignal()
            .emit(onNext: { searchResults in

                output.appInfos.accept(searchResults.results)

                var section: [SearchResultSection.SearchResultSectionModel]

                if output.isEditingSearchBar.value {
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

                output.sections.accept(section)
            })
            .disposed(by: disposeBag)

        return output
    }
}
