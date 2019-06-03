//
//  AppDelegate.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import UIKit
import Stripe
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup your firebase account
        FirebaseApp.configure()
        
        // setup your stripe account
        STPPaymentConfiguration.shared().publishableKey = "<--YourStripeKey-->"
        
        return true
    }
}

