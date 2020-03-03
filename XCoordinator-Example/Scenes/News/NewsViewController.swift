//  
//  NewsViewController.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, BindableType {
    
    enum Section {
        case news
    }
    
    var viewModel: NewsViewModel!

    // MARK: Views

    @IBOutlet private var tableView: UITableView!

    // MARK: Stored properties

    private var cancellables = Set<AnyCancellable>()
    private let tableViewCellIdentifier = String(describing: DetailTableViewCell.self)
    private var dataSource: UITableViewDiffableDataSource<Section, News>!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = 44
        
        dataSource = UITableViewDiffableDataSource<Section, News>(tableView: self.tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = self.tableView.dequeueReusableCell(type: DetailTableViewCell.self, forIndexPath: indexPath)
            
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subtitle
            cell.imageView?.image = model.image
            cell.selectionStyle = .none
            
            return cell
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    // MARK: BindableType

    func bindViewModel() {
                
        viewModel
            .output
            .news
            .sink { [unowned self] (news) in
                var snapshot = NSDiffableDataSourceSnapshot<Section, News>()
                snapshot.appendSections([.news])
                snapshot.appendItems(news, toSection: .news)
                
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
        
        viewModel
            .output
            .title
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let news = dataSource.itemIdentifier(for: indexPath) else {
            fatalError("Did select unknown item at indexpath \(indexPath)")
        }
        viewModel.input.selectedNews.send(news)
    }
}
