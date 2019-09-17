//  
//  AboutViewController.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class AboutViewController: UIViewController, BindableType {

    var viewModel: AboutViewModel!

    // MARK: Views

    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var openWebsiteButton =
        UIBarButtonItem(title: "Website", style: .done,
                        target: self, action: #selector(openWebsite))

    // MARK: Stored properties

    private let disposeBag = DisposeBag()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "XCoordinator"
        navigationItem.rightBarButtonItem = openWebsiteButton
        setupWebView()
    }

    // MARK: BindableType

    func bindViewModel() {
        let request = URLRequest(url: viewModel.output.url)
        webView.load(request)
    }

    // MARK: Actions

    @objc
    private func openWebsite() {
        viewModel.input.openWebsiteTrigger.onNext(())
    }

    // MARK: Helpers

    private func setupWebView() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}
