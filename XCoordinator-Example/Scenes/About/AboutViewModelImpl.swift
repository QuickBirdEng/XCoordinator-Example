//  
//  AboutViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import XCoordinator
import Combine

class AboutViewModelImpl: AboutViewModel, AboutViewModelInput, AboutViewModelOutput {
    // MARK: Inputs
    
    private(set) var openWebsiteTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: Outputs

    let url = URL(string: "https://github.com/quickbirdstudios/XCoordinator")!

    // MARK: Stored properties

    private let router: UnownedRouter<AboutRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(router: UnownedRouter<AboutRoute>) {
        self.router = router
        openWebsiteTrigger.sink { [unowned self] _ in
            self.router.trigger(.website)
        }.store(in: &cancellables)
    }
}
