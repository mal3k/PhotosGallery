//
//  UsersViewController.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit
import iProgressHUD

class UsersViewController: UIViewController, UISplitViewControllerDelegate {

    var viewModel: UsersViewModel!
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                           forCellReuseIdentifier: UserTableViewCell.identifier)
        let progressHUD = iProgressHUD.sharedInstance()
        progressHUD.indicatorStyle = .ballPulseSync
        progressHUD.attachProgress(toView: view)
        view.showProgress()
        viewModel.onViewDidLoad()
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.user = self.viewModel.users[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}
extension UsersViewController: ViewModelDelegate {
    func onFetchCompleted() {
        DispatchQueue.main.async {
            self.view.dismissProgress()
            self.tableView.reloadData()
        }
    }
    func onFetchFailed(with error: String) {
    }
}
