//
//  NewsCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

/// Routes for the news flow: the news list, a specific article, and a "close everything" command
/// that returns to the flow's root.
enum NewsRoute: Route {
    /// Push the news list. Used as the initial route.
    case news
    /// Push a detail screen for a specific article.
    case newsDetail(News)
    /// Dismiss everything pushed by this coordinator back to its root.
    case close
}

/// News flow inside a `UINavigationController`. Owns the news list and the article-detail push.
class NewsCoordinator: NavigationCoordinator<NewsRoute> {

    // MARK: Initialization

    init() {
        super.init(initialRoute: .news)
    }

    // MARK: Overrides

    override func prepareTransition(for route: NewsRoute) -> NavigationTransition {
        switch route {
        case .news:
            let viewController = NewsViewController.instantiateFromNib()
            let service = MockNewsService()
            let viewModel = NewsViewModelImpl(newsService: service, router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .newsDetail(let news):
            let viewController = NewsDetailViewController.instantiateFromNib()
            let viewModel = NewsDetailViewModelImpl(news: news)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .swirl)
        case .close:
            return .dismissToRoot()
        }
    }

}
