//  
//  HomeViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

protocol HomeViewModelInput {
    var logoutTrigger: PassthroughSubject<Void, Never> { get }
    var usersTrigger: PassthroughSubject<Void, Never> { get }
    var aboutTrigger: PassthroughSubject<Void, Never> { get }
}

protocol HomeViewModelOutput {}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }

    func registerPeek(for sourceView: Container)
}

extension HomeViewModel where Self: HomeViewModelInput & HomeViewModelOutput {
    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }
}
