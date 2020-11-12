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
    
    var status: (user: String, source: String) = ("", "")
    var media_sources = [MediaSources]()
    
    func getDataFromDeeplink(deeplink: String?, completion: (ResultData?) -> ()) {
        
        if deeplink == "" {
            print("empty deeplink - go further")
            completion(nil)
            return
        }
        
        guard let deeplink = deeplink else {
            print("no deeplink")
            completion(nil)
            return
        }
        // get deeplink and proccess it into deeplinkData in ResultData format
        
        let queries = Utils().getQueriesFromDeeplink(deeplink)
        print("Deeplink queries are \(queries)")
        
        
        
        let deeplinkData = ResultData(key: "", sub1: "", sub2: "", sub3: "", source: TrafficSource.FACEBOOK)
        
        completion(deeplinkData)
    }
    
    func getDataFromNaming(naming: String?, mediaSources: [MediaSources], completion: (ResultData?) -> ()) {
        
        if naming == "" {
            print("empty naming - go further")
            completion(nil)
            return
        }
        
        guard let naming = naming else {
            print("no naming")
            completion(nil)
            return
        }
        // get naming and proccess it into namingData in ResultData format
        
        let queries = Utils().getQueriesFromNaming(naming)
        print("Naming queries are \(queries)")
        
        
        
        let namingData = ResultData(key: "", sub1: "", sub2: "", sub3: "", source: TrafficSource.FACEBOOK)
        
        completion(namingData)
    }
    
    func createDataFromResult(_ data: ResultData, _ status: (String , String), _ callback: () -> Void) {
        
        // create link from passed params
        let link = "https://egame.site/click.php"
        
        
    }
    
    func requestData(callback: () -> Void) {
        
        print("\nUser - \(status.user) \nSource - \(status.source)")
        
        if status.user != "true" {
            print("\nUser not true")
            return
        }
        
        // user == "true" - check deeplink
        getDataFromDeeplink(deeplink: "") { deeplinkData -> () in
            
            if deeplinkData != nil {
                print("Deeplink data - \(deeplinkData!)")
                createDataFromResult(deeplinkData!, status, callback)
                return
            }
            
            // no deeplink - check naming
            getDataFromNaming(naming: "", mediaSources: media_sources) { namingData -> () in
                
                if namingData != nil {
                    print("Naming data - \(namingData!)")
                    createDataFromResult(namingData!, status, callback)
                    return
                }
                
                // no naming - create organic
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
                createDataFromResult(organicData, status, callback)
            }
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
            print(self.status)
            
            let mediaSources = (res.media_sources)
            self.media_sources = mediaSources
            
            var sourceNum = 0
            
            for media in mediaSources {
                print("\nMedia source \(sourceNum): ")
                
                print(media.source ?? "no source")
                print("\(media.media_source)")
                
                //                print("Key details:")
                //                print(media.key.name)
                //                print(media.key.split)
                //                print(media.key.delimiter)
                //                print(media.key.position)
                //
                //                print("Sub1 details: ")
                //                print(media.sub1.name)
                //                print(media.sub1.split)
                //                print(media.sub1.delimiter)
                //                print(media.sub1.position)
                //
                //                print("Sub2 details: ")
                //                print(media.sub2.name)
                //                print(media.sub2.split)
                //
                //                print("Sub1 details: ")
                //                print(media.sub3.name)
                //                print(media.sub3.split)
                
                sourceNum += 1
            }
        }
    }
}
