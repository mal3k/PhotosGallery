//
//  AlbumsViewController.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit
import JGProgressHUD

class AlbumsViewController: UIViewController {

    private static let cellIdentifier = "AlbumCell"
    var viewModel: AlbumsViewModel!
    private var tableView: UITableView!
    private lazy var progressHUD = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AlbumsViewController.cellIdentifier)
        progressHUD.style = .dark
        progressHUD.show(in: self.view)
        viewModel.onViewDidLoad()
    }
    deinit {
        viewModel.onDeinit()
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
            self.progressHUD.dismiss()
            self.tableView.reloadData()
        }
    }
    func onFetchFailed(with error: String) {
        print(error)
    }
}
