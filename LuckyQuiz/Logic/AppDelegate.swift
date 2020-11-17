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
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let logic = NewLogic()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppEvents.activateApp()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            
            if let error = error {
                print("Received error while fetching deferred app link: \(error)")
                
            } else if let deeplink = url?.absoluteString {
                print(deeplink)
                UserDefaults.standard.set(deeplink, forKey: "deeplink")
                
            } else {
                print("\nNo app link available\n")
            }
            
            self.logic.requestData()
        }
        
        // MARK: - OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
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
