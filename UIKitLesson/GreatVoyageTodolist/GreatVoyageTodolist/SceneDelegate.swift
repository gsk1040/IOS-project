//
//  SceneDelegate.swift
//  GreatVoyageTodolist
//
//  Created by 원대한 on 4/6/25.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    // scene이 연결될 때 초기 설정을 수행하는 메서드
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // scene이 UIWindowScene 타입인지 확인
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Firebase 초기화 중복 방지 (만약 AppDelegate에서 호출하지 않았다면 여기서 호출)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // 새로운 UIWindow 인스턴스를 생성하여 windowScene에 연결
        window = UIWindow(windowScene: windowScene)

        // LoginViewController를 네비게이션 컨트롤러에 담아 루트 뷰 컨트롤러로 설정
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navController

        // 윈도우를 보이도록 설정
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

