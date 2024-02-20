//
//  GenresViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class GenresViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var genresCollectionView: UICollectionView!
    // MARK: - Properties
    private var presenter: GenresPresenterProtocol?
    private let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchGenreData()
        setupCollectionView(genresCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        genresCollectionView.reloadData()
    }
}

extension GenresViewController {
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.registerCell(type: GenresCell.self)
    }
}

extension GenresViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItemAt(index: indexPath.item)
    }
}

extension GenresViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genresCollectionView.dequeueCell(indexPath: indexPath) as GenresCell
        guard let presenter = presenter else { return cell }
        let data = presenter.cellForItemAt(index: indexPath.item)
        let cellEntity: GenresViewEntity = GenresViewEntity(response: GenreResponseEntity(id: data.id,
                                                                                              name: data.name))
        cell.setupCellUI(cellEntity)
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension GenresViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height / 4)
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

extension GenresViewController: GenresViewProtocol {
    func set(presenter: GenresPresenterProtocol) {
        self.presenter = presenter
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.genresCollectionView.reloadData()
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
