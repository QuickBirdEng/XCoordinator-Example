//  
//  LoginViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator
import Combine

protocol LoginViewModelInput {
    var loginTrigger: PassthroughSubject<Void, Never> { get }
}

protocol LoginViewModelOutput { }

protocol LoginViewModel {
    var input: LoginViewModelInput { get }
    var output: LoginViewModelOutput { get }
}

extension LoginViewModel where Self: LoginViewModelInput & LoginViewModelOutput {
    var input: LoginViewModelInput { return self }
    var output: LoginViewModelOutput { return self }
}
