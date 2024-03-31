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
    }
    struct Output {
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
                self.useCase.requestSearch(term: term)
            })
            .disposed(by: disposeBag)

        useCase.searchResults
            .asSignal()
            .emit(onNext: { searchResults in
                output.appInfos.accept(searchResults.results)
            })
            .disposed(by: disposeBag)

        return output
    }
}
