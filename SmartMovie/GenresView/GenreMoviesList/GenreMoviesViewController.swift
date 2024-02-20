//
//  GenreMoviesViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 05/04/2023.
//

import UIKit

final class GenreMoviesViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var genreMoviesCollectionView: UICollectionView!
    @IBOutlet weak var viewLoadMore: UIView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var presenter: GenreMoviesPresenterProtocol?
    private let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.backgroundColor = .black
        loadingIndicator.startAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        genreMoviesCollectionView.reloadData()
    }
}

extension GenreMoviesViewController {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.registerCell(type: ListMovieCell.self)
    }

    private func setupLoadMore() {
        viewLoadMore.backgroundColor = .black
        viewLoadMore.isHidden = true
        loadMoreHeightConstraint.constant = 0
    }
}

extension GenreMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItemAt(index: indexPath.item)
    }
}

extension GenreMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreMoviesCollectionView.dequeueCell(indexPath: indexPath) as ListMovieCell

        guard let presenter = presenter else { return cell }
        cell.setupCellUI(presenter.cellForItemAt(index: indexPath.item))
        cell.layer.cornerRadius = 10
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loadMoreIndicator.isAnimating {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if !loadMoreIndicator.isAnimating {
                loadMoreIndicator.startAnimating()
                viewLoadMore.isHidden = false
                loadMoreHeightConstraint.constant = 50
                presenter?.fetchMoreData {
                    DispatchQueue.main.async {
                        self.loadMoreIndicator.stopAnimating()
                        self.viewLoadMore.isHidden = true
                        self.loadMoreHeightConstraint.constant = 0
                    }
                }
            }
        }
    }
}

extension GenreMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height / 5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension GenreMoviesViewController: GenreMoviesViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.genreMoviesCollectionView.reloadData()
        }
    }

    func set(presenter: GenreMoviesPresenterProtocol) {
        self.presenter = presenter
    }

    func setUpUI() {
        DispatchQueue.main.async {
            self.setupCollectionView(self.genreMoviesCollectionView)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            self.setupLoadMore()
        }
    }

    func displayError(completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Load Data Failed",
                                          message: "Can't get data from server, please try again later.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { _ in
                completion()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
