//  
//  NewsDetailViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

class NewsDetailViewModelImpl: NewsDetailViewModel, NewsDetailViewModelInput, NewsDetailViewModelOutput {

    // MARK: Outputs

    let news: AnyPublisher<News, Never>

    // MARK: Initialization

    init(news: News) {
        self.news = Just(news).eraseToAnyPublisher()
    }
}
