//
//  DetailViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 02/04/2023.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDetailLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var viewSeeMore: UIView!

    private var presenter: DetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp))
        gesture.direction = .up
        overviewLabel.addGestureRecognizer(gesture)
        overviewLabel.isUserInteractionEnabled = true
        setupTableView(detailTableView)
        viewContainer.alpha = 0.0
        movieImageView.layer.cornerRadius = 10
    }

    @objc private func didSwipeUp() {
        UIView.animate(withDuration: 0.3) {
            self.viewSeeMore.alpha = 1.0
            self.overviewLabel.numberOfLines = 3
            self.viewContainer.superview?.layoutIfNeeded()
        }
    }

    @IBAction func invokeBackButton(_ sender: Any) {
        presenter?.back()
    }

    @IBAction func didTapOnSeeMore(_ sender: Any) {
        if detailTableView.isDragging {
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.viewSeeMore.alpha = 0.0
            self.overviewLabel.numberOfLines = 0
            self.viewContainer.superview?.layoutIfNeeded()
        }
    }
}

extension DetailViewController {
    private func setupTableView(_ tableView: UITableView) {
        tableView.alpha = 0.0
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCell(type: DetailTableViewCell.self)
        tableView.registerCell(type: SearchTableViewCell.self)
        tableView.register(CustomDetailHeader.self, forHeaderFooterViewReuseIdentifier: "CustomDetailHeader")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupSeeMoreBTN() {
        overviewLabel.numberOfLines = 0
        let maxSize = CGSize(width: overviewLabel.bounds.width, height: .greatestFiniteMagnitude)
        let textRect = overviewLabel.textRect(forBounds: CGRect(origin: .zero, size: maxSize),
                                              limitedToNumberOfLines: overviewLabel.numberOfLines)
        let lineHeight = overviewLabel.font.lineHeight
        let numberOfLines = Int(ceil(textRect.height / lineHeight)) - 1
        if numberOfLines > 3 {
            overviewLabel.numberOfLines = 3
            viewSeeMore.isHidden = false
        }
    }
}

extension DetailViewController: UITableViewDelegate {
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSection() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else {
            return UITableViewCell()
        }
        let cellIdentifier = presenter.cellIdentifierForRowAt(indexPath)
        switch cellIdentifier {
        case "DetailTableViewCell":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                           for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
            }
            cell.setupCellUI(presenter.cellForRowAt(indexPath) as? [CastingDisplayModel] ?? [])
            return cell
        case "SearchTableViewCell":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                           for: indexPath) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            cell.setupCellUI(presenter.cellForRowAt(indexPath) as? MovieDisplayModel ?? MovieDisplayModel())
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = detailTableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomDetailHeader") as?
                CustomDetailHeader else {
            return UIView()
        }
        header.titleLabel.text = presenter?.titleForHeaderInSection(section)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter?.heightForHeaderInSection(section) ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.heightForRowAt(indexPath) ?? 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if overviewLabel.numberOfLines == 0 {
            if scrollView.contentOffset.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.overviewLabel.numberOfLines = 3
                    self.viewContainer.superview?.layoutIfNeeded()
                    self.viewSeeMore.alpha = 1.0
                }
            }
        }
    }
}

extension DetailViewController: DetailViewProtocol {
    func setupData(_ data: MovieDisplayModel) {
        DispatchQueue.main.async {
            self.backdropImageView.image = UIImage(named: "gradient")
            self.movieImageView.kf.setImage(with: URL(string: "\(ServerConstant.URLBase.imageURL)\(data.posterPath)"),
                                       placeholder: UIImage(named: "placeholder"),
                                       options: [
                                        .transition(.fade(0.3)),
                                        .cacheOriginalImage
            ])
            self.movieTitleLabel.text = data.title
            self.movieGenres.text = data.genres.map({ $0.name ?? "" }).joined(separator: " | ")
            setStar(data.voteAverage, self.starStackView)
            self.voteLabel.text = "\(Int((data.voteAverage) / 2)) / 5"
            self.languageLabel.text = changeLanguage(data.language)
            self.releaseDetailLabel.text = data.releaseDate
            self.overviewLabel.text = data.overview
            UIView.animate(withDuration: 0.3, animations: {
                DispatchQueue.main.async {
                    self.viewContainer.alpha = 1.0
                    self.detailTableView.alpha = 1.0
                    self.setupSeeMoreBTN()
                }
            })
        }
    }

    func set(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
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
