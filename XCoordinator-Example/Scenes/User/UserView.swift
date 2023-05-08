//
//  UserView.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCoordinator
import SwiftUI

struct UserView: View {

    // MARK: Stored Properties

    let username: String

    @Routing(UserRoute.self) private var router

    // MARK: Computed Properties

    var body: some View {
        let content = VStack(spacing: 64) {
            Text(username)
                .font(.title)

            Button("Show Alert") {
                router.trigger(UserRoute.alert(title: "Hey", message: "You are awesome!"))
            }
        }

        if #available(iOS 14, *) {
            content.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        router.trigger(UserRoute.users)
                    }
                }
            }
        } else {
            content.navigationBarItems(
                leading: Button("Close") {
                    router.trigger(UserRoute.users)
                }
            )
        }
    }

}
