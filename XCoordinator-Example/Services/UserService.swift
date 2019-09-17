//
//  UserService.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import RxSwift

protocol UserService {
    func allUsers() -> Observable<[User]>
}
