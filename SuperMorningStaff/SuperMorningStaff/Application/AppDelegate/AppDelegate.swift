//
//  AppDelegate.swift
//  SuperMorningStaff
//
//  Created by Monu Rathor on 21/05/22.
//

import UIKit
import CommonUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var navigation: CoordinatedNavigationController = {
        let navigation = CoordinatedNavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
        return navigation
    }()

    private lazy var coordinator: AppCoordinator = {
        AppCoordinator(router: navigation)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator.start()

        window = UIWindow()
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }

}

