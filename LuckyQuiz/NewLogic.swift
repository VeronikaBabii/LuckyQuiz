//
//  NewLogic.swift
//  LuckyQuiz
//
//  Created by Veronika Babii on 11.11.2020.
//  Copyright © 2020 Veronika Babii. All rights reserved.
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

class NewLogic {
    
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
            
            print("\(result!.source)")
            print("\(result!.user)")
            
            let mediaSources = (result!.media_sources)
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
