//  
//  NewsViewModel.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine

protocol NewsViewModelInput {
    var selectedNews: PassthroughSubject<News, Never> { get }
}

protocol NewsViewModelOutput {
    var news: AnyPublisher<[News], Never> { get }
    var title: AnyPublisher<String?, Never> { get }
}

protocol NewsViewModel {
    var input: NewsViewModelInput { get }
    var output: NewsViewModelOutput { get }
}

extension NewsViewModel where Self: NewsViewModelInput & NewsViewModelOutput {
    var input: NewsViewModelInput { return self }
    var output: NewsViewModelOutput { return self }
}
