//
//  SceneDelegate.swift
//  Magic 8-ball
//
//  Created by Vladyslav Taranenko on 20.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainViewController")
        if let mainViewController = initialViewController as? MainViewController {
            mainViewController.networkAnswerProvider = NetworkAnswerClient()
        }
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

