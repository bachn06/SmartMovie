//
//  HomeViewController.swift
//  SmartMovie
//
//  Created by BachNguyen on 29/03/2023.
//

import UIKit

class AppSettings {
    static var isGrid: Bool = true
}

final class HomeViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var changeViewButton: UIButton!

    private var presenter: HomePresenterProtocol?
    private var underlineViewLeadingConstraint: NSLayoutConstraint!
    private var underlineViewWidthConstraint: NSLayoutConstraint!
    private let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: nil)
    private var subViewControllers: [UIViewController] = []
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        setupPageView()
        setupMenuBar()
        changeImageBtn()
    }

    @IBAction func invokeChangeViewBtn(_ sender: UIButton) {
        AppSettings.isGrid = !AppSettings.isGrid
        changeImageBtn()
        NotificationCenter.default.post(name: NSNotification.Name("changeGrid"), object: nil)
    }

    private func changeImageBtn() {
        if !AppSettings.isGrid {
            changeViewButton.setImage(.init(systemName: "rectangle.grid.1x2.fill"), for: .normal)
        } else {
            changeViewButton.setImage(.init(systemName: "square.grid.2x2.fill"), for: .normal)
        }
    }
}

extension HomeViewController {
    private func setupMenuBar() {
        viewMenu.backgroundColor = .black
        pageCollectionView.registerCell(type: PageCategoryCell.self)
        pageViewController.delegate = self
        pageCollectionView.backgroundColor = .black
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        collectionViewLayout.scrollDirection = .horizontal
        pageCollectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineViewWidthConstraint = underlineView.widthAnchor.constraint(
            equalToConstant: view.frame.width / CGFloat(subViewControllers.count)
        )
        underlineViewWidthConstraint.isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        underlineViewLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: viewMenu.leadingAnchor)
        underlineViewLeadingConstraint.isActive = true
        underlineView.bottomAnchor.constraint(equalTo: viewMenu.bottomAnchor).isActive = true
        underlineView.backgroundColor = .systemRed
    }

    private func setupPageView() {
        guard let navigationController = navigationController else { return }
        let allMovies = MoviesCoordinator(navigationController: navigationController).startMovies()
        subViewControllers = [allMovies]
        pageViewController.dataSource = self
        pageViewController.setViewControllers([subViewControllers[0]], direction: .forward, animated: true)
        addChild(pageViewController)
        pageView.backgroundColor = .black
        pageView.addSubview(pageViewController.view)
        pageViewController.view.frame = pageView.bounds
        pageViewController.didMove(toParent: self)
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(goToPage),
                                               name: NSNotification.Name("goToPage"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appendPopular),
                                               name: NSNotification.Name("appendPopular"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appendTopRated),
                                               name: NSNotification.Name("appendTopRated"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appendUpComing),
                                               name: NSNotification.Name("appendUpComing"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appendNowPlaying),
                                               name: NSNotification.Name("appendNowPlaying"),
                                               object: nil)
    }

    @objc func goToPage(_ notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String else { return }
        let index = presenter?.getIndexTitle(title: title) ?? 0
        let indexPath = IndexPath(item: index, section: 0)
        let direction: UIPageViewController.NavigationDirection = currentPage < index ? .forward : .reverse
        currentPage = index
        pageCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        pageViewController.setViewControllers([subViewControllers[index]], direction: direction, animated: true)
        let underlineWidth = viewMenu.frame.width / CGFloat(subViewControllers.count)
        underlineViewLeadingConstraint.constant = CGFloat(index) * underlineWidth
        underlineViewWidthConstraint.constant = viewMenu.frame.width / CGFloat(subViewControllers.count)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func appendPopular() {
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else { return }
            let popular = PopularCoordinator(navigationController: navigationController).startPopular()
            self.presenter?.appendTitle(title: AppConstant.Title.popular)
            self.subViewControllers.append(popular)
            let underlineWidth = self.viewMenu.frame.width / CGFloat(self.subViewControllers.count)
            self.underlineViewWidthConstraint.constant = underlineWidth
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func appendTopRated() {
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else { return }
            let topRated = TopRatedCoordinator(navigationController: navigationController).startTopRated()
            self.subViewControllers.append(topRated)
            self.presenter?.appendTitle(title: AppConstant.Title.topRated)
            let underlineWidth = self.viewMenu.frame.width / CGFloat(self.subViewControllers.count)
            self.underlineViewWidthConstraint.constant = underlineWidth
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func appendUpComing() {
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else { return }
            let upComing = UpComingCoordinator(navigationController: navigationController).startUpComing()
            self.subViewControllers.append(upComing)
            self.presenter?.appendTitle(title: AppConstant.Title.upComing)
            let underlineWidth = self.viewMenu.frame.width / CGFloat(self.subViewControllers.count)
            self.underlineViewWidthConstraint.constant = underlineWidth
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func appendNowPlaying() {
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else { return }
            let nowPlaying = NowPlayingCoordinator(navigationController: navigationController).startNowPlaying()
            self.subViewControllers.append(nowPlaying)
            self.presenter?.appendTitle(title: AppConstant.Title.nowPlaying)
            let underlineWidth = self.viewMenu.frame.width / CGFloat(self.subViewControllers.count)
            self.underlineViewWidthConstraint.constant = underlineWidth
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath: indexPath) as PageCategoryCell
        if indexPath.item < presenter?.getTitle().count ?? 0 {
            cell.setupCell(with: presenter?.getTitle()[indexPath.item] ?? "")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("goToPage"),
                                        object: nil,
                                        userInfo: ["title": presenter?.getTitle()[indexPath.item] ?? ""])
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(subViewControllers.count),
                      height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return subViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = subViewControllers.firstIndex(of: viewController), index < subViewControllers.count - 1 else {
            return nil
        }
        return subViewControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let currentViewController = pageViewController.viewControllers?.first else { return }
        guard let currentIndex = subViewControllers.firstIndex(of: currentViewController) else { return }
        pageCollectionView.selectItem(at: IndexPath(item: currentIndex, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredHorizontally)
        let underlineWidth = viewMenu.frame.width / CGFloat(subViewControllers.count)
        underlineViewLeadingConstraint.constant = CGFloat(currentIndex) * underlineWidth
        underlineViewWidthConstraint.constant = underlineWidth
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    func set(presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.pageCollectionView.reloadData()
        }
    }
}
