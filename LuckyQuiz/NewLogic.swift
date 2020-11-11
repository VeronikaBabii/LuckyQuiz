//
//  NewLogic.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct Responce: Decodable {
    var source: String
    var user: String
    var media_sources: [MediaSourses]
}

struct MediaSourses: Decodable {
    var source: String?
    var media_source: String
    var key: MediaSource
    var sub1: MediaSource
    var sub2: Media
    var sub3: Media
}

struct MediaSource: Decodable {
    var name: String
    var split: Bool
    var delimiter: String
    var position: Int
}

struct Media: Decodable {
    var name: String
    var split: Bool
}

//
struct ResultData {
    var key: String
    var sub1: String
    var sub2: String
    var sub3: String
    var source: TrafficSource
}

enum TrafficSource {
    case FACEBOOK
    case UNITY
    case GOOGLE
}

class NewLogic {
    
    func requestData() {
        
        
        
    }
    
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
        
        let url = URL(string: "https://integr-testing.site/checker/?token=jCMs3QPM7gsT5D3V")!
        
        getDataFromChecker(url: url) { result in
            
            guard let res = result else {
                print("Result is nil")
                return
            }
            
            UserDefaults.standard.set(res.source, forKey: "fb-source")
            print(UserDefaults.standard.object(forKey: "source") ?? "no source")
            
            UserDefaults.standard.set(res.user, forKey: "fb-user")
            print(UserDefaults.standard.object(forKey: "fb-user") ?? "no user")
            
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
