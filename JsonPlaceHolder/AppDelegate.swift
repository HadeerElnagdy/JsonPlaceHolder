//
//  AppDelegate.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
              window = UIWindow(frame: UIScreen.main.bounds)
              let initialViewController = ProfileTableViewController()
              window?.rootViewController = initialViewController
              window?.makeKeyAndVisible()
              return true
          }

}

