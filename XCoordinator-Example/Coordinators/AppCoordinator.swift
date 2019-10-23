//
//  AppCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case login
    case home(StrongRouter<HomeRoute>?)
    case newsDetail(News)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    // MARK: Initialization

    init() {
        super.init(initialRoute: .login)
    }

    // MARK: Overrides

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewController = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case let .home(router):
            if let router = router {
                return .presentFullScreen(router, animation: .fade)
            }
            let alert = UIAlertController(
                title: "How would you like to login?",
                message: "Please choose the type of coordinator used for the `Home` scene.",
                preferredStyle: .alert)
            alert.addAction(
                .init(title: "\(HomeTabCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomeTabCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "\(HomeSplitCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomeSplitCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "\(HomePageCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomePageCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "Random", style: .default) { [unowned self] _ in
                    let routers: [() -> StrongRouter<HomeRoute>] = [
                        { HomeTabCoordinator().strongRouter },
                        { HomeSplitCoordinator().strongRouter },
                        { HomeTabCoordinator().strongRouter }
                    ]
                    let router = routers.randomElement().map { $0() }
                    self.trigger(.home(router))
                }
            )
            return .present(alert)
        case .newsDetail(let news):
            return .multiple(
                .dismissAll(),
                .popToRoot(),
                deepLink(AppRoute.home(HomePageCoordinator().strongRouter),
                         HomeRoute.news,
                         NewsRoute.newsDetail(news))
            )
        }
    }

    // MARK: Methods

    func notificationReceived() {
        guard let news = MockNewsService().mostRecentNews().articles.randomElement() else {
            return
        }
        self.trigger(.newsDetail(news))
    }

}
