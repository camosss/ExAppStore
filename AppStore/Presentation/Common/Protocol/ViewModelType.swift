//
//  ViewModelType.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import Foundation
import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
