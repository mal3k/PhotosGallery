//
//  PhotosViewController.swift
//  PhotosGallery
//
//  Created by Malek TRABELSI on 20/01/2021.
//

import UIKit
import Kingfisher

class PhotosViewController: UIViewController {

    var viewModel: PhotosViewModel!
    private var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        viewModel.onViewDidLoad()
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    // swiftlint:disable line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:enable line_length
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        let photo = viewModel.photos[indexPath.item]
        cell.photoTitleLabel.text = photo.title
        guard let url = URL(string: photo.thumbnailURL)
        else {
            return cell
        }
        cell.photoThumbnailImageView.kf.setImage(with: url)
        return cell
    }
}
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    // swiftlint:disable line_length
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 212, height: 318)
    }
}
extension PhotosViewController: ViewModelDelegate {
    func onFetchCompleted() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func onFetchFailed(with error: String) {
    }
}
