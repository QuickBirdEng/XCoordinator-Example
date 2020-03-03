//  
//  NewsDetailViewController.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class NewsDetailViewController: UIViewController, BindableType {
    var viewModel: NewsDetailViewModel!

    // MARK: Views

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentTextView: UITextView!

    // MARK: Stored properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: Overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentTextView.setContentOffset(.zero, animated: false)
    }

    // MARK: BindableType

    func bindViewModel() {
        viewModel.output.news
            .map { $0.title + "\n" + $0.subtitle }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: titleLabel)
            .store(in: &cancellables)
        
        viewModel.output.news
            .map { $0.content }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: contentTextView)
            .store(in: &cancellables)

        viewModel.output.news
            .map { $0.image }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
    }
}
