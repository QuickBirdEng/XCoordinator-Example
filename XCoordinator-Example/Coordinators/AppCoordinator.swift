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
    case home((any Router<HomeRoute>)?)
    case newsDetail(News)
}

extension Coordinator {
    typealias Prepare = TransitionBuilder<RootViewController>
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    // MARK: Initialization

    init() {
        super.init(initialRoute: .login)
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: AppRoute) -> Transition<RootViewController> {
        switch route {
        case .login:
            Push {
                let viewController = LoginViewController.instantiateFromNib()
                let viewModel = LoginViewModelImpl(router: self)
                viewController.bind(to: viewModel)
                return viewController
            }
        case let .home(router):
            if let router {
                Present(animation: .fade) {
                    router.viewController.modalPresentationStyle = .fullScreen
                    return router.asPresentable
                }
            } else {
                Present {
                    let alert = UIAlertController(
                        title: "How would you like to login?",
                        message: "Please choose the type of coordinator used for the `Home` scene.",
                        preferredStyle: .alert)
                    alert.addAction(
                        .init(title: "\(HomeTabCoordinator.self)", style: .default) { [unowned self] _ in
                            self.trigger(.home(HomeTabCoordinator()))
                        }
                    )
                    alert.addAction(
                        .init(title: "\(HomeSplitCoordinator.self)", style: .default) { [unowned self] _ in
                            self.trigger(.home(HomeSplitCoordinator()))
                        }
                    )
                    alert.addAction(
                        .init(title: "\(HomePageCoordinator.self)", style: .default) { [unowned self] _ in
                            self.trigger(.home(HomePageCoordinator()))
                        }
                    )
                    alert.addAction(
                        .init(title: "Random", style: .default) { [unowned self] _ in
                            let router: any Router<HomeRoute> = {
                                switch Int.random(in: 0..<3) {
                                case 0:
                                    return HomeTabCoordinator()
                                case 1:
                                    return HomeSplitCoordinator()
                                default:
                                    return HomeTabCoordinator()
                                }
                            }()
                            self.trigger(.home(router))
                        }
                    )
                    return alert
                }
            }
        case .newsDetail(let news):
            DismissAll()
            Pop(toRoot: true)
            DeepLink(
                with: self,
                AppRoute.home(HomePageCoordinator()),
                HomeRoute.news,
                NewsRoute.newsDetail(news)
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
