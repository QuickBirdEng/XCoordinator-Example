//  
//  UserViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class UserViewController: UIViewController, BindableType {
    var viewModel: UserViewModel!

    // MARK: Views

    @IBOutlet private var username: UILabel!
    @IBOutlet private var showAlertButton: UIButton!
    private var closeBarButtonItem: UIBarButtonItem!

    // MARK: Stored properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    // MARK: BindableType

    func bindViewModel() {
        viewModel.output.username
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: username)
            .store(in: &cancellables)

        showAlertButton.tapPublisher
            .sink(receiveValue: viewModel.input.alertTrigger.send)
            .store(in: &cancellables)
        
        closeBarButtonItem.tapPublisher
            .sink(receiveValue: viewModel.input.closeTrigger.send)
            .store(in: &cancellables)
    }

    // MARK: Helpers

    private func configureNavigationBar() {
        closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
}
