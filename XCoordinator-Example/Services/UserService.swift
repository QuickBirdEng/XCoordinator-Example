//
//  UserService.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

protocol UserService {
    func allUsers() -> [User]
}

class MockUserService: UserService {
    func allUsers() -> [User] {
        let names = [
            "Stefan", "Malte", "Sebi",
            "Niko", "Balazs", "Patrick",
            "Julian", "Quirin", "Paul",
            "Michael", "Eduardo", "Lizzie"
        ]
        return names.map(User.init)
    }
}
