//
//  AlbumsViewController.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit
import iProgressHUD

class AlbumsViewController: UIViewController {

    private static let cellIdentifier = "AlbumCell"
    var viewModel: AlbumsViewModel!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AlbumsViewController.cellIdentifier)
        let progressHUD = iProgressHUD.sharedInstance()
        progressHUD.indicatorStyle = .ballPulseSync
        progressHUD.attachProgress(toView: view)
        view.showProgress()
        viewModel.onViewDidLoad()
    }
}
extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsViewController.cellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.viewModel.albums[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}

extension AlbumsViewController: ViewModelDelegate {
    func onFetchCompleted() {
        DispatchQueue.main.async {
            self.view.dismissProgress()
            self.tableView.reloadData()
        }
    }
    func onFetchFailed(with error: String) {
        print(error)
    }
}
