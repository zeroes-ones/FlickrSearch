//
//  FlickrSearchViewController.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import SwiftUI

final class FlickrSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: FlickrSearchViewModel!
    private var navigator: PhotosNaviator?
    private var searchText: String = ""
    @Environment(\.imageCache) private var cache: ImageCache

    static func makeViewController(viewModel: FlickrSearchViewModel, navigator: PhotosNaviator) -> FlickrSearchViewController {
        let vc = FlickrSearchViewController.instantiateFromStoryboard("Flickr", storyboardId: "FlickrSearchViewController")
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc
    }
}

extension FlickrSearchViewController {
    override func viewDidLoad() {
        title = "Flickr"
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        configureHierarchy()
        observeModelChanges()
    }
}

private extension FlickrSearchViewController {

    func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        SwiftUICollectionViewCell<FlickrImageViewCell>.register(with: collectionView)
    }

    /// Observes the data changes and upddates the UI
    func observeModelChanges() {
        viewModel.photoList.producer
            .observe(on: QueueScheduler.main)
            .startWithValues { [weak self] newValues in
                guard let self = self else { return }
                self.collectionView.reloadData()
        }
    }

    /// function to create compositional layout for collectionview
    private static func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.supplementariesFollowContentInsets = true

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

}

//MARK: - CollectionView DataSource Delegate
extension FlickrSearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photoList.value[section].photos?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.photoList.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photo = viewModel.photoList.value[indexPath.section].photos?[indexPath.row] else {
                return UICollectionViewCell()
        }
        let cell = SwiftUICollectionViewCell<FlickrImageViewCell>.dequeue(
            from: collectionView,
            for: indexPath
        )
        cell.setView(FlickrImageViewCell(photo: photo, imageCache: cache))
        return cell
    }
}

//MARK: - CollectionView Delegate
extension FlickrSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = viewModel.photoList.value[indexPath.section].photos?[indexPath.row] else {
            return
        }
        navigator?.navigate(to: .photo(photo: photo, imageCache: cache, fullScreen: true), type: .push)
    }
}

//MARK: - Searchbar Delegate
extension FlickrSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        searchText = text
        searchBar.resignFirstResponder()
        viewModel.fetchPhotos(for: text, isInitialLoad: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - Scrollview Delegate
extension FlickrSearchViewController: UIScrollViewDelegate {

    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                //Start locading new data from here
                viewModel.fetchPhotos(for: searchText)
            }
        }
    }

    // MARK :- Hide keyboard if active on searchbar
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
