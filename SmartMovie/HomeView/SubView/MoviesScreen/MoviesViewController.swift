//
//  MoviesViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    private var presenter: MoviesPresenterProtocol?
    private let layout = UICollectionViewFlowLayout()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.backgroundColor = .black
        loadingIndicator.startAnimating()
        presenter?.fetchData {
            DispatchQueue.main.async {
                self.setupCollectionView(self.moviesCollectionView)
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.setupRefreshControl()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesCollectionView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MoviesViewController {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.registerHeader(type: HeaderCollectionReusableView.self)
        collectionView.registerCell(type: GridMovieCell.self)
        collectionView.registerCell(type: ListMovieCell.self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cellGrid),
                                               name: Notification.Name("changeGrid"),
                                               object: nil)
    }

    @objc func cellGrid() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .white
        moviesCollectionView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        self.presenter?.refreshData {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.moviesCollectionView.reloadData()
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItemAt(section: indexPath.section, index: indexPath.item)
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.numberOfSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemInSection(section: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = moviesCollectionView.dequeueHeader(indexPath: indexPath) as HeaderCollectionReusableView
        if let title = presenter?.getSectionTitle(section: indexPath.section) {
            header.setupHeaderUI(title)
        }
        return header
    }

    private func cellForGridMode(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath: indexPath) as GridMovieCell
        cell.layer.cornerRadius = 10
        guard let presenter = presenter else { return cell }
        cell.setupCellUI(presenter.cellForItemAt(section: indexPath.section, index: indexPath.item))
        return cell
    }

    private func cellForListMode(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath: indexPath) as ListMovieCell
        cell.layer.cornerRadius = 10
        guard let presenter = presenter else { return cell }
        cell.setupCellUI(presenter.cellForItemAt(section: indexPath.section, index: indexPath.item))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if AppSettings.isGrid {
            return cellForGridMode(collectionView: collectionView, indexPath: indexPath)
        } else {
            return cellForListMode(collectionView: collectionView, indexPath: indexPath)
        }
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 50)
    }

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

extension MoviesViewController: MoviesViewProtocol {
    func set(presenter: MoviesPresenterProtocol) {
        self.presenter = presenter
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
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
