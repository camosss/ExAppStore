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
        let searchBarTerm: Signal<String>
        let searchItemDidTap: Signal<Int>
        let shouldLoadResult: Signal<Void>
    }
    struct Output {
        let isEditingSearchBar = BehaviorRelay<Bool>(value: false)
        let currentTerm = BehaviorRelay<String>(value: "")
        let sections = BehaviorRelay<[SearchResultSection.SearchResultSectionModel]>(value: [])
        let appInfos = BehaviorRelay<[AppInfo]>(value: [])
    }

    private let useCase: SearchUseCase
    var disposeBag = DisposeBag()

    // MARK: - Init

    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        let output = Output()

        input.searchBarTerm
            .asSignal()
            .emit(onNext: { [weak self] term in
                guard let self = self else { return }

                output.isEditingSearchBar.accept(true)
                output.currentTerm.accept(term)

                self.useCase.requestSearch(term: term)
            })
            .disposed(by: disposeBag)

        input.searchItemDidTap
            .asSignal()
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                if output.isEditingSearchBar.value {
                    output.isEditingSearchBar.accept(false)

                    let appInfo = output.appInfos.value[index]
                    if let trackName = appInfo.trackName {
                        output.currentTerm.accept(trackName)
                        self.useCase.requestSearch(term: trackName)
                    }
                }
            })
            .disposed(by: disposeBag)

        input.shouldLoadResult
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }

                output.isEditingSearchBar.accept(false)
                self.useCase.requestSearch(term: output.currentTerm.value)
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
