import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // 프로필 뷰 컨트롤러만 탭으로 설정
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        // 필요에 따라 다른 탭을 추가할 수 있음
        // 예: 홈, 알림, 설정 등
        
        viewControllers = [
            UINavigationController(rootViewController: profileVC)
        ]
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = UIColor(red: 88/255, green: 126/255, blue: 255/255, alpha: 1)
        tabBar.backgroundColor = UIColor.white
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
    }
}

#Preview {
    MainTabBarController()
}
