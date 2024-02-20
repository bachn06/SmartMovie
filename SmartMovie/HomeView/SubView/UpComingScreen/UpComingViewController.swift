//
//  UpComingViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class UpComingViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewLoadMore: UIView!
    @IBOutlet weak var loadMoreHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var presenter: UpComingPresenterProtocol?
    private let layout = UICollectionViewFlowLayout()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.backgroundColor = .black
        loadingIndicator.startAnimating()
        presenter?.fetchData(1) {
            DispatchQueue.main.async {
                self.setupCollectionView(self.upComingCollectionView)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.setupLoadMore()
                self.setupRefreshControl()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        upComingCollectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension UpComingViewController {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.registerCell(type: GridMovieCell.self)
        collectionView.registerCell(type: ListMovieCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(cellGrid),
                                               name: Notification.Name("changeGrid"),
                                               object: nil)
    }

    @objc func cellGrid() {
        DispatchQueue.main.async {
            self.upComingCollectionView.reloadData()
        }
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        upComingCollectionView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        presenter?.refreshData(completion: {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        })
    }

    private func setupLoadMore() {
        viewLoadMore.backgroundColor = .black
        viewLoadMore.isHidden = true
        loadMoreHeightConstraint.constant = 0
    }
}

extension UpComingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItemAt(index: indexPath.item)
    }
}

extension UpComingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if AppSettings.isGrid {
            let cell = upComingCollectionView.dequeueCell(indexPath: indexPath) as GridMovieCell
            cell.layer.cornerRadius = 10
            guard let presenter = presenter else { return cell }
            cell.setupCellUI(presenter.cellForItemAt(index: indexPath.item))
            return cell
        } else {
            let cell = upComingCollectionView.dequeueCell(indexPath: indexPath) as ListMovieCell
            cell.layer.cornerRadius = 10
            guard let presenter = presenter else { return cell }
            cell.setupCellUI(presenter.cellForItemAt(index: indexPath.item))
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loadMoreIndicator.isAnimating {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if loadMoreIndicator.isAnimating == false {
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

extension UpComingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if AppSettings.isGrid == false {
            return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height / 4)
        }
        return CGSize(width: (collectionView.bounds.width - 50) / 2, height: collectionView.bounds.height / 2.5)
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

extension UpComingViewController: UpComingViewProtocol {
    func set(presenter: UpComingPresenterProtocol) {
        self.presenter = presenter
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.upComingCollectionView.reloadData()
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
