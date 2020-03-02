//  
//  NewsViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

class NewsViewModelImpl: NewsViewModel, NewsViewModelInput, NewsViewModelOutput {

    // MARK: Inputs

    private(set) lazy var selectedNews = PassthroughSubject<News, Never>()

    // MARK: Actions

    lazy var newsSelectedAction: (News) -> Void = { [unowned self] news in
        self.router.trigger(.newsDetail(news))
    }

    // MARK: Outputs

    private(set) lazy var news = newsPublisher.map { $0.articles }.eraseToAnyPublisher()
    private(set) lazy var title = newsPublisher.map { $0.title as String? }.eraseToAnyPublisher()

    let newsPublisher: AnyPublisher<(title: String, articles: [News]), Never>

    // MARK: Stored properties

    private let newsService: NewsService
    private let router: UnownedRouter<NewsRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(newsService: NewsService, router: UnownedRouter<NewsRoute>) {
        self.newsService = newsService
        self.newsPublisher = Just(newsService.mostRecentNews())
            .eraseToAnyPublisher()
        self.router = router
        
        selectedNews
            .sink(receiveValue: newsSelectedAction)
            .store(in: &cancellables)
    }
}
