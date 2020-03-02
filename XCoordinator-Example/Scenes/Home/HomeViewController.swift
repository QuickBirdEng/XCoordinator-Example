//  
//  HomeViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class HomeViewController: UIViewController, BindableType {
    var viewModel: HomeViewModel!

    // MARK: Views

    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var usersButton: UIButton!
    @IBOutlet private var aboutButton: UIButton!
    
    // MARK: Stored properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
    }

    // MARK: BindableType

    func bindViewModel() {
        logoutButton.tapPublisher
            .sink(receiveValue: viewModel.input.logoutTrigger.send)
            .store(in: &cancellables)
        
        usersButton.tapPublisher
            .sink(receiveValue: viewModel.input.usersTrigger.send)
            .store(in: &cancellables)
        
        aboutButton.tapPublisher
            .sink(receiveValue: viewModel.input.aboutTrigger.send)
            .store(in: &cancellables)

        viewModel.registerPeek(for: usersButton)
    }
}
