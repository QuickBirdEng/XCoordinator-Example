//
//  DeepLinkParser.swift
//  XCoordinator-Example
//
//  Copyright © 2026 QuickBird Studios. All rights reserved.
//

import Foundation

/// Maps incoming URLs to `AppRoute` values that the existing deep-link transition chain can handle.
///
/// Recognised schemes:
/// - `xcoordinator-example://news/<id>`        — open a specific article (id is the article's index)
/// - `xcoordinator-example://users/<username>` — open a specific user's detail screen
///
/// Anything else returns `nil`; callers ignore unknown URLs rather than crashing.
enum DeepLinkParser {

    static let scheme = "xcoordinator-example"

    static func parse(_ url: URL) -> AppRoute? {
        guard url.scheme == scheme else { return nil }
        switch url.host {
        case "news":
            guard let idString = url.pathComponents.dropFirst().first,
                  let id = Int(idString) else { return nil }
            let articles = MockNewsService().mostRecentNews().articles
            guard articles.indices.contains(id) else { return nil }
            return .newsDetail(articles[id])
        case "users":
            guard let username = url.pathComponents.dropFirst().first,
                  !username.isEmpty else { return nil }
            return .userDetail(username: username)
        default:
            return nil
        }
    }
}
