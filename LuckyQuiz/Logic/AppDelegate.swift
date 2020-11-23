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
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {
    
    @objc func sendLaunch(app: Any) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - AppsFlyer
        AppsFlyerTracker.shared().appsFlyerDevKey = ""
        AppsFlyerTracker.shared().appleAppID = "354340085862913"
        AppsFlyerTracker.shared().delegate = self
        //AppsFlyerTracker.shared().isDebug = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // MARK: - Fb deeplinking
        AppEvents.activateApp()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // fetch deeplink and add to UserDefaults
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            
            if let deeplink = url?.absoluteString {
                print(deeplink)
                UserDefaults.standard.set(deeplink, forKey: "deeplink")
            } else {
                //print("\nNo app link available or error fetching deeplink\n")
                UserDefaults.standard.set(nil, forKey: "deeplink")
            }
        }
        
        // TODO: fetch naming and add to UD
        
        
        // call request method
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NewLogic().requestData()
        }
        
        // MARK: - OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "a7e60277-d981-4310-82f1-e790e23777a4", handleNotificationAction: nil, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // to show the iOS push notification prompt
        // OneSignal.promptForPushNotifications(userResponse: { accepted in
        //   print("User accepted notifications: \(accepted)")
        // })
        
        return true
    }
    
    // MARK: - Track App Installs and App Opens
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        //AppsFlyerTracker.shared().start()
    }
    
    // Open Univerasal Links
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("User info \(userInfo)")
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    
    // Open Deeplinks
    // Open URI-scheme for iOS 8 and below
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }
    
    // Open URI-scheme for iOS 9 and above
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
    
    // MARK: - AppsFlyerTracker protocol implementation
    // code from AF guide
    
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
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
