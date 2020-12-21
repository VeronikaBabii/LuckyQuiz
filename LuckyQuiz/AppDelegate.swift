//
//  AppDelegate.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 20.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import OneSignal
import AppsFlyerLib
import FBSDKCoreKit
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {
    
    @objc func sendLaunch(app: Any) { AppsFlyerTracker.shared().trackAppLaunch() }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppsFlyerTracker.shared().appsFlyerDevKey = Consts.APPSFLYER_DEV_KEY
        AppsFlyerTracker.shared().appleAppID = Consts.APPLE_APP_ID
        AppsFlyerTracker.shared().delegate = self
        //AppsFlyerTracker.shared().isDebug = true
        NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: Consts.METRICA_SDK_KEY)
        configuration?.handleActivationAsSessionStart = true
        //configuration?.logs = true
        YMMYandexMetrica.activate(with: configuration!)
        
        AppEvents.activateApp()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
                print("Error fetching app link: \n\(error)")
                UserDefaults.standard.set(nil, forKey: "deep")
            } else if let deep = url?.absoluteString {
                print("App link is present")
                UserDefaults.standard.set(deep, forKey: "deep")
            } else {
                print("No app link available")
                UserDefaults.standard.set(nil, forKey: "deep")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { Logic().requestData() }
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions, appId: Consts.ONESIGNAL_ID, handleNotificationAction: nil, settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("User info \(userInfo)")
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
    
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        var dataDict = [AnyHashable: Any]()
        for (key, value) in installData {
            print(key, ":", value)
            dataDict[key] = value
        }
        UserDefaults.standard.set(dataDict, forKey: "dataDict")
        
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"], let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else { print("This is an organic install.") }
            
            if let is_first_launch = installData["is_first_launch"] as? Bool, is_first_launch {
                UserDefaults.standard.set("true", forKey: "isFirstLaunch")
                print("First Launch")
            } else {
                UserDefaults.standard.set("false", forKey: "isFirstLaunch")
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) { print(error) }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) { print(error) }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
