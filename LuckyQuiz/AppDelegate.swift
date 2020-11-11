//
//  AppDelegate.swift
//  WebViewDemo
//
//  Created by Mark Vais on 20.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    let utils = Utils()
    let logic = NewLogic()
    let vc = ViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - fb setup code
        AppEvents.activateApp()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) // handle login action
        
        // fb deeplinking
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            
            var queries = [String: String]()
            
            if let error = error {
                print("Received error while fetching deferred app link: \(error)")
                
            } else if let url = url?.absoluteString {
                print("\n\(url)\n")
                
                queries = self.utils.getQueriesFromDeeplink(url)
                
            } else { // no fb deeplink - process organic deeplink (add custom parameters to our craft link)
                print("\nNo app link available\n")
                
                queries["key"] = "9mn79hcpu4dwnr9vq385"
                queries["sub1"] = "organic"
            }
            
            queries["sub4"] = Bundle.main.bundleIdentifier
            queries["sub5"] = self.utils.getUniqueID()
            //print("\(queries)\n")
            
            // sort query dictionary (key, sub1, sub2...)
            let sortedBySubs = queries.sorted(by: <)
            //print("\(sortedBySubs)\n")
            
            // add formed web url to show to UserDefaults
            let AGREEMENT_URL = self.utils.formUrlToShow(sortedBySubs)
            
            UserDefaults.standard.set(AGREEMENT_URL, forKey: "AGREEMENT_URL")
            //print("now showing - \(AGREEMENT_URL)\n")
            
            //self.utils.checkAgreementStatus()
            self.logic.checkerDataUsage()
        }
        
        // MARK: - OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // add OneSignal app id
        OneSignal.initWithLaunchOptions(launchOptions, appId: "a7e60277-d981-4310-82f1-e790e23777a4", handleNotificationAction: nil, settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        // to show the iOS push notification prompt
//        OneSignal.promptForPushNotifications(userResponse: { accepted in
//          print("User accepted notifications: \(accepted)")
//        })
        
        return true
    }
    
    // MARK: - Track App Installs and App Opens
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
