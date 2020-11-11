//
//  NewLogic.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

class NewLogic {
    
    //MARK: - deeplink/naming/organic logic
    let placeholder = ResultData(key: "", sub1: "", sub2: "", sub3: "", source: TrafficSource.FACEBOOK)
    
    var status: (user: String, source: String)? = nil
    
    func getDataFromDeeplink(completion: (ResultData?) -> ()) {
        
        if true {
            print("deeplink data must be here")
            completion(placeholder)
        } else {
            print("nil")
            completion(nil)
        }
    }

    func getDataFromNaming(mediaSources: String, completion: (ResultData?) -> ()) {
        
        if mediaSources == "Facebook" {
            print("naming data must be here")
            completion(placeholder)
        } else {
            print("nil")
            completion(nil)
        }
    }

    // pass data here and create link
    func createDataFromResult(_ data: ResultData, _ status: String, _ callback: String) {
        
    }

    func requestData() {
        
        print("\nUser - \(status?.user ?? "") \nSource - \(status?.source ?? "")")
        
        if status?.user != "true" {
            print("\nUser not true")
        }
         
        // user == "true" - check deeplink
        getDataFromDeeplink() { deeplinkData -> () in
            
            if deeplinkData != nil {
                print(deeplinkData!)
                createDataFromResult(deeplinkData!, "status", "callback")
            }
            
            // no deeplink - check naming
            getDataFromNaming(mediaSources: "Facebook") { namingData -> () in
                
                if namingData != nil {
                    print(namingData!)
                    createDataFromResult(namingData!, "status", "callback")
                }
            }
            
            // no naming - create organic
            var computedKey: String {
                if status?.source == TrafficSource.FACEBOOK.rawValue {
                    return Consts.ORGANIC_FB
                } else {
                    return Consts.ORGANIC_INAPP
                }
            }
            
            var computedSub1: String {
                if status?.source == TrafficSource.FACEBOOK.rawValue {
                    return "organic_fb"
                } else {
                    return "organic_inapp"
                }
            }
            
            let organicData = ResultData(key: computedKey, sub1: computedSub1, source: TrafficSource.FACEBOOK)
            print(organicData)
            createDataFromResult(organicData, "status", "callback")
        }
    }
    
    //MARK: - parse jsonData from checker api
    func getDataFromChecker (url: URL, completion: @escaping(Responce?) -> Void) {
        
        URLSession.shared.dataTask(with: url) {data, _, error in
            
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
    
    func checkerDataUsage() {
        
        let url = URL(string: "https://integr-testing.site/checker/?token=\(Consts.CLOAK_TOKEN)")!
        
        getDataFromChecker(url: url) { result in
            
            guard let res = result else {
                print("Result is nil")
                return
            }
            
            self.status = (res.user, res.source)
            print(self.status ?? ())
            
            let mediaSources = (res.media_sources)
            var sourceNum = 0
            
            for media in mediaSources {
                print("\nMedia source \(sourceNum): ")
                
                print(media.source ?? "no source")
                print("\(media.media_source)\n")
                
                print("Key details:")
                print(media.key.name)
                print(media.key.split)
                print(media.key.delimiter)
                print(media.key.position)
                
                print("Sub1 details: ")
                print(media.sub1.name)
                print(media.sub1.split)
                print(media.sub1.delimiter)
                print(media.sub1.position)
                
                print("Sub2 details: ")
                print(media.sub2.name)
                print(media.sub2.split)
                
                print("Sub1 details: ")
                print(media.sub3.name)
                print(media.sub3.split)
                
                sourceNum += 1
            }
        }
    }
}
