//  
//  LoginViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class LoginViewController: UIViewController, BindableType {
    var viewModel: LoginViewModel!

    // MARK: Views

    @IBOutlet private var loginButton: UIButton!

    // MARK: Stored properties
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
    }

    // MARK: BindableType

    func bindViewModel() {
        loginButton
            .tapPublisher
            .sink(receiveValue: viewModel.input.loginTrigger.send)
            .store(in: &cancellables)
    }
}
