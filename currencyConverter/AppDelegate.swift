//
//  AppDelegate.swift
//  currencyConverter
//
//  Created by Tyra Elliott Neftzger on 12/16/21.
//  Copyright © 2021 Tyra Elliott Neftzger. All rights reserved.
//

import UIKit
import SailthruMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SailthruMobile().startEngine("24ab7c7359499c27bad4e4d1e1ada8dec4ed6089")
        return true
    }
}

