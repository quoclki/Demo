//
//  AppDelegate.swift
//  Todo
//
//  Created by Lu Kien Quoc on 25/12/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Base.shared.initBase()
        return true
    }


}

