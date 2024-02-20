//
//  SearchViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchImageView: UIImageView!

    private var presenter: SearchPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchImageView.image = UIImage(named: "searching")
        loadingIndicator.backgroundColor = .black
        loadingIndicator.isHidden = true
        setupTableView(searchTableView)
        searchTextField.delegate = self
    }

    @IBAction func didChangeOnSearchTF(_ sender: Any) {
        if searchTextField.text == "" {
            searchImageView.image = UIImage(named: "searching")
            searchImageView.isHidden = false
            searchTableView.isHidden = true
            return
        }
        searchTableView.isHidden = false
        searchImageView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.searchTableView.alpha = 0.0
        }, completion: { _ in
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            self.presenter?.fetchSearchResult(query: self.searchTextField.text ?? "") {
                DispatchQueue.main.async {
                    if self.presenter?.resultSearchMovies().isEmpty == true {
                        self.searchImageView.image = UIImage(named: "empty")
                        self.searchImageView.isHidden = false
                        self.searchTableView.isHidden = true
                    }
                    self.searchTableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    UIView.animate(withDuration: 0.3, animations: {
                        self.searchTableView.alpha = 1.0
                    })
                }
            }
        })
    }

    @IBAction func didTapOnCancelButton(_ sender: Any) {
        searchTextField.text = ""
        presenter?.cancelSearch()
        searchImageView.isHidden = false
        searchTableView.isHidden = true
        searchTextField.resignFirstResponder()
    }
}

extension SearchViewController {
    private func setupTableView(_ tableView: UITableView) {
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerCell(type: SearchTableViewCell.self)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectItemAt(index: indexPath.row)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueCell(indexPath: indexPath) as SearchTableViewCell
        guard let presenter = presenter else { return cell }
        cell.layer.cornerRadius = 10
        cell.setupCellUI(presenter.cellForRowAt(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        searchTableView.frame.height / 2.5
    }
}

extension SearchViewController: SearchViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }

    func set(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
    }

    func displayError(completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Load Data Failed",
                                          message: "Can't get data from server, please try again later.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { _ in
                self?.presenter?.fetchSearchResult(query: self?.searchTextField.text ?? "", completion: {
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                        self?.loadingIndicator.isHidden = true
                        UIView.animate(withDuration: 0.3, animations: {
                            self?.searchTableView.alpha = 1.0
                        })
                    }
                })
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
