//
//  TestViewController.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    // MARK: Stored Properties

    var backgroundColor: UIColor? {
        didSet {
            viewIfLoaded?.backgroundColor = backgroundColor
        }
    }

    var text: String? {
        didSet {
            label.text = text
        }
    }

    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 48)
        return view
    }()

    // MARK: Initialization

    convenience init(color backgroundColor: UIColor?, text: String?) {
        self.init()
        self.backgroundColor = backgroundColor
        self.text = text
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        label.text = text

        view.addSubview(label)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: label.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: label.leadingAnchor),
        ])
    }

}
