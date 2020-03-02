//  
//  UsersViewController.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, BindableType {
    
    enum Section {
        case users
    }
    
    var viewModel: UsersViewModel!

    // MARK: Views

    @IBOutlet private var tableView: UITableView!

    // MARK: Stored properties

    private var cancellables = Set<AnyCancellable>()
    private let cellIdentifier = String(describing: DetailTableViewCell.self)
    private var dataSource: UITableViewDiffableDataSource<Section, User>!

    // MARK: Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableViewCell()
        configureNavigationBar()
        
        dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView) { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(type: DetailTableViewCell.self, forIndexPath: indexPath)
            cell.textLabel?.text = user.name
            cell.selectionStyle = .none
            return cell
        }
    }

    // MARK: BindableType

    func bindViewModel() {
        viewModel.output.users
            .sink { (users) in
                var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
                
                snapshot.appendSections([.users])
                snapshot.appendItems(users, toSection: .users)
                
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else {
            fatalError("Could not select item at indexpath \(indexPath)")
        }
        viewModel.input.showUserTrigger.send(user)
    }

    // MARK: Helpers

    private func configureTableViewCell() {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    private func configureNavigationBar() {
        title = "Users"
    }
}
