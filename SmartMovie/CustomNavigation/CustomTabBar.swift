//
//  CustomTabBar.swift
//  SmartMovie
//
//  Created by BachNguyen on 09/04/2023.
//

import UIKit

final class CustomTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
        tabBar.barTintColor = .black
        tabBar.tintColor = .red
        tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)],
                                                         for: .normal)
    }

    private func setupTabBar() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let homeView = homeCoordinator.startHome()
        homeView.tabBarItem = UITabBarItem(title: AppConstant.Title.home,
                                           image: UIImage(systemName: "house"), tag: 0)
        let homeNavigation = UINavigationController(rootViewController: homeView)
        homeNavigation.navigationBar.barTintColor = .black
        homeNavigation.navigationBar.tintColor = .white
        homeNavigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        homeNavigation.navigationBar.isTranslucent = false
        homeNavigation.isNavigationBarHidden = false
        homeCoordinator.navigationController = homeNavigation

        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        let searchView = searchCoordinator.startSearch()
        searchView.tabBarItem = UITabBarItem(title: AppConstant.Title.search,
                                             image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let searchNavigation = UINavigationController(rootViewController: searchView)
        searchNavigation.navigationBar.barTintColor = .black
        searchNavigation.navigationBar.tintColor = .white
        searchNavigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        searchNavigation.navigationBar.isTranslucent = false
        searchCoordinator.navigationController = searchNavigation

        let genresCoordinator = GenresCoordinator(navigationController: UINavigationController())
        let genresView = genresCoordinator.startGenres()
        genresView.tabBarItem = UITabBarItem(title: AppConstant.Title.genres,
                                             image: UIImage(systemName: "list.bullet"), tag: 2)
        let genresNavigation = UINavigationController(rootViewController: genresView)
        genresNavigation.navigationBar.barTintColor = .black
        genresNavigation.navigationBar.tintColor = .white
        genresNavigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        genresNavigation.navigationBar.isTranslucent = false
        genresCoordinator.navigationController = genresNavigation

        let artistsCoordinator = ArtistsCoordinator(navigationController: UINavigationController())
        let artistView = artistsCoordinator.startArtists()
        artistView.tabBarItem = UITabBarItem(title: AppConstant.Title.artists,
                                             image: UIImage(systemName: "person.2"), tag: 3)
        let artistNavigation = UINavigationController(rootViewController: artistView)
        artistNavigation.navigationBar.barTintColor = .black
        artistNavigation.navigationBar.tintColor = .white
        artistNavigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        artistNavigation.navigationBar.isTranslucent = false
        artistsCoordinator.navigationController = artistNavigation

        viewControllers = [homeNavigation, searchNavigation, genresNavigation, artistNavigation]
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController {
            nav.isNavigationBarHidden = false
            nav.popToRootViewController(animated: true)
        }
    }
}
