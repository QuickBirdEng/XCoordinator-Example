//  
//  NewsViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class NewsViewModelImpl: NewsViewModel, NewsViewModelInput, NewsViewModelOutput {

    // MARK: Inputs

    private(set) lazy var selectedNews = newsSelectedAction.inputs

    // MARK: Actions

    lazy var newsSelectedAction = Action<News, Void> { [unowned self] news in
        self.router.rx.trigger(.newsDetail(news))
    }

    // MARK: Outputs

    private(set) lazy var news = newsObservable.map { $0.articles }
    private(set) lazy var title = newsObservable.map { $0.title }

    let newsObservable: Observable<(title: String, articles: [News])>

    // MARK: Stored properties

    private let newsService: NewsService
    private let router: UnownedRouter<NewsRoute>

    // MARK: Initialization

    init(newsService: NewsService, router: UnownedRouter<NewsRoute>) {
        self.newsService = newsService
        self.newsObservable = .just(newsService.mostRecentNews())
        self.router = router
    }

}
