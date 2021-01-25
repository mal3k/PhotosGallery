//
//  UsersViewController.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit
import JGProgressHUD

class UsersViewController: UIViewController {

    var viewModel: UsersViewModel!
    private var tableView: UITableView!
    private lazy var progressHUD = JGProgressHUD()
    private var resultsController: UITableViewController!
    private var searchController: UISearchController!

    fileprivate func setupView() {
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                           forCellReuseIdentifier: UserTableViewCell.identifier)
        progressHUD.style = .dark
        progressHUD.show(in: self.view)
        resultsController = UITableViewController(style: .plain)
        resultsController.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                                             forCellReuseIdentifier: UserTableViewCell.identifier)
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.onViewDidLoad()
    }
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.resultsController.tableView:
            return viewModel.filteredUsers.count
        default:
            return viewModel.users.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier,
                                                 for: indexPath) as! UserTableViewCell
        // swiftlint:enable force_cast
        switch tableView {
        case self.resultsController.tableView:
            cell.user = self.viewModel.filteredUsers[indexPath.row]
        default:
            cell.user = self.viewModel.users[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.resultsController.tableView:
            viewModel.didSelectSearchResultsRow(at: indexPath.row)
        default:
            viewModel.didSelectRow(at: indexPath.row)
        }
    }
}

extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = self.searchController.searchBar.text
        else {
            return
        }
        self.viewModel.onSearch(with: text)
    }
}
extension UsersViewController: ViewModelDelegate {
    func onFetchCompleted() {
        DispatchQueue.main.async {
            self.progressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    func onFetchFailed(with error: String) {
    }
    func reloadSearchResults() {
        self.resultsController.tableView.reloadData()
    }
}
