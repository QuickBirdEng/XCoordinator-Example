//
//  NewsCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum NewsRoute: Route {
    case news
    case newsDetail(News)
    case close
}

class NewsCoordinator: NavigationCoordinator<NewsRoute> {

    // MARK: Initialization

    init() {
        super.init(initialRoute: .news)
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: NewsRoute) -> Transition<RootViewController> {
        switch route {
        case .news:
            Push {
                let viewController = NewsViewController.instantiateFromNib()
                let service = MockNewsService()
                let viewModel = NewsViewModelImpl(newsService: service, router: self)
                viewController.bind(to: viewModel)
                return viewController
            }
        case .newsDetail(let news):
            let animation: Animation = {
                if #available(iOS 10.0, *) {
                    return .swirl
                } else {
                    return .scale
                }
            }()
            Push(animation: animation) {
                let viewController = NewsDetailViewController.instantiateFromNib()
                let viewModel = NewsDetailViewModelImpl(news: news)
                viewController.bind(to: viewModel)
                return viewController
            }
        case .close:
            Dismiss(toRoot: true)
        }
    }

}
