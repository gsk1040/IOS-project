//
//  ViewController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//

//
//  MainTabBarController.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//


import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // 홈 탭
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "항해", image: UIImage(systemName: "map"), tag: 0)
        
        // 도전과제 탭
        /*let challengesVC = ChallengesViewController()
        let challengesNav = UINavigationController(rootViewController: challengesVC)
        challengesNav.tabBarItem = UITabBarItem(title: "도전", image: UIImage(systemName: "exclamationmark.triangle"), tag: 1)*/
        
        // 보물 탭
        let treasuresVC = TreasuresViewController()
        let treasuresNav = UINavigationController(rootViewController: treasuresVC)
        treasuresNav.tabBarItem = UITabBarItem(title: "보물", image: UIImage(systemName: "star"), tag: 2)
        
        // 프로필 탭
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), tag: 3)
        
        viewControllers = [homeNav, treasuresNav, profileNav]
        
        // 탭바 스타일링
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ViewController()
}


