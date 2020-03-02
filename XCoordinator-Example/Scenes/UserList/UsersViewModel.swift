//  
//  UsersViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine

protocol UsersViewModelInput {
    var showUserTrigger: PassthroughSubject<User, Never> { get }
}

protocol UsersViewModelOutput {
    var users: AnyPublisher<[User], Never> { get }
}

protocol UsersViewModel {
    var input: UsersViewModelInput { get }
    var output: UsersViewModelOutput { get }
}

extension UsersViewModel where Self: UsersViewModelInput & UsersViewModelOutput {
    var input: UsersViewModelInput { return self }
    var output: UsersViewModelOutput { return self }
}
