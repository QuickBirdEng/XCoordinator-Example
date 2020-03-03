//  
//  UserViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine

protocol UserViewModelInput {
    var alertTrigger: PassthroughSubject<Void, Never> { get }
    var closeTrigger: PassthroughSubject<Void, Never> { get }
}

protocol UserViewModelOutput {
    var username: AnyPublisher<String?, Never> { get }
}

protocol UserViewModel {
    var input: UserViewModelInput { get }
    var output: UserViewModelOutput { get }
}

extension UserViewModel where Self: UserViewModelInput & UserViewModelOutput {
    var input: UserViewModelInput { return self }
    var output: UserViewModelOutput { return self }
}
