//  
//  AboutViewModel.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

protocol AboutViewModelInput {
    var openWebsiteTrigger: PassthroughSubject<Void, Never> { get }
}

protocol AboutViewModelOutput {
    var url: URL { get }
}

protocol AboutViewModel {
    var input: AboutViewModelInput { get }
    var output: AboutViewModelOutput { get }
}

extension AboutViewModel where Self: AboutViewModelInput & AboutViewModelOutput {
    var input: AboutViewModelInput { return self }
    var output: AboutViewModelOutput { return self }
}
