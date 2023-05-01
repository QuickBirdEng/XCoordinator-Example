//  
//  AboutViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import RxSwift
import Action
import XCoordinator

class AboutViewModelImpl: AboutViewModel, AboutViewModelInput, AboutViewModelOutput {

    // MARK: Inputs

    private(set) lazy var openWebsiteTrigger = openWebsiteAction.inputs

    // MARK: Actions

    private lazy var openWebsiteAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.website)
    }

    // MARK: Outputs

    let url = URL(string: "https://github.com/quickbirdstudios/XCoordinator")!

    // MARK: Stored properties

    private unowned let router: any Router<AboutRoute>

    // MARK: Initialization

    init(router: any Router<AboutRoute>) {
        self.router = router
    }

}
