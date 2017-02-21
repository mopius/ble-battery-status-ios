//
//  AppDelegate.swift
//  BatteryStatus
//
//  Created by Patrick Steiner on 20.02.17.
//  Copyright © 2017 Mopius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        
        return true
    }
    
    private func setupUI() {
        // navigation bar
        UINavigationBar.appearance().barTintColor = AppConstants.mainColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // set status bar text color to white
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
        // tabbar
        UITabBar.appearance().tintColor = AppConstants.mainColor
        UITabBar.appearance().isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : AppConstants.mainColor], for: .selected)
    }
}

