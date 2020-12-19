//
//  AppDelegate.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 20.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import OneSignal
import AppsFlyerLib
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {
    
    @objc func sendLaunch(app: Any) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - AppsFlyer
        AppsFlyerTracker.shared().appsFlyerDevKey = Consts.APPSFLYER_DEV_KEY
        AppsFlyerTracker.shared().appleAppID = Consts.APPLE_APP_ID
        AppsFlyerTracker.shared().delegate = self
        //AppsFlyerTracker.shared().isDebug = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // MARK: - Yandex AppMetrica
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: Consts.METRICA_SDK_KEY)
        
        configuration?.handleActivationAsSessionStart = true
        //configuration?.logs = true
        
        YMMYandexMetrica.activate(with: configuration!)
        
//        let params : [String : Any] = ["key1": "value1", "key2": "value2"]
//        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { (error) in
//            print("DID FAIL REPORT EVENT: %@")
//            print("REPORT ERROR: %@", error.localizedDescription)
//        })
        
        // MARK: - Fb deeplinking
        AppEvents.activateApp()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            
            if let error = error {
                print("Received error while fetching deferred app link: \(error)")
                UserDefaults.standard.set(nil, forKey: "deeplink")
                
            } else if let deeplink = url?.absoluteString {
                print(deeplink)
                UserDefaults.standard.set(deeplink, forKey: "deeplink")
                
            } else {
                print("\nNo app link available\n")
                UserDefaults.standard.set(nil, forKey: "deeplink")
            }
        }
        
        // call request method
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NewLogic().requestData()
        }
        
        // MARK: - OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: Consts.ONESIGNAL_ID, handleNotificationAction: nil, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        AppsFlyerTracker.shared().trackAppLaunch()
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
        
        var namingDataDict = [AnyHashable: Any]()
        
        for (key, value) in installData {
            print(key, ":", value)
            namingDataDict[key] = value
        }
        print("\n\(namingDataDict)\n")
        
        UserDefaults.standard.set(namingDataDict, forKey: "namingDataDict")
        
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool, is_first_launch {
                UserDefaults.standard.set("true", forKey: "isFirstLaunch")
                print("First Launch")
            } else {
                UserDefaults.standard.set("false", forKey: "isFirstLaunch")
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
