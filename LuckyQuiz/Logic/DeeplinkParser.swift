//
//  DeeplinkParser.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 12.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct InnerAppLinkData: Decodable {
    var target_url: String
    var extras: Extras
}

struct Extras: Decodable {
    var key: String
    var sub1: String
    var sub2: String?
    var sub3: String?
}

class DeeplinkParser {
    
    // 1 - get deeplink and form jsonStr from in
    func formJsonStr(deeplink: String) -> String {
        
        // 1 - receive deeplink
        print("\(deeplink)\n")
        
        // 2 - split by al_applink_data=
        let outerApplink = deeplink.components(separatedBy: "al_applink_data=")[1]
        print("\(outerApplink)\n")
        
        // 3 - decode
        let decodedApplink = outerApplink.removingPercentEncoding!
        print("\(decodedApplink)\n")
        
        // 4 - split by al_applink_data=
        let innerApplink = decodedApplink.components(separatedBy: "al_applink_data=")[1]
        print("\(innerApplink)\n")
        
        // 5 - get rid of unneeded extras part
        let withoutExtras = innerApplink.components(separatedBy: "\",\"")[0]
        print("\(withoutExtras)\n")
        
        // 6 - get rid of \
        let withoutBadSymbols = withoutExtras.replacingOccurrences(of: "\\", with: "")
        
        return withoutBadSymbols
    }
    
    // 2 - jsonStr to Json and then decode via structs
    func decodeJSON(jsonString: String, completion: @escaping (InnerAppLinkData?) -> Void) {
        
        print("\(jsonString)\n")
        
        let data = jsonString.data(using: .utf8)!
        
        do {
            let decodedData = try JSONDecoder().decode(InnerAppLinkData.self, from: data)
            print(decodedData)
            completion(decodedData)
        }
        catch {
            print(error)
            completion(nil)
        }
    }
    
    // 3 - get deeplink params from decoded Json
    func getParamsFromDeeplink(deeplink: String) -> [String: String] {
        let parse = DeeplinkParser()
        
        let jsonStr = parse.formJsonStr(deeplink: deeplink)

        var queriesDict = [String: String]()
        
        parse.decodeJSON(jsonString: jsonStr) { result in
            
            guard let result = result else {
                print("Result is empty")
                return
            }
            
            // neccessary params
            print(result.extras.key)
            queriesDict["key"] = result.extras.key
            
            print(result.extras.sub1)
            queriesDict["sub1"] = result.extras.sub1
            
            // optional params
            if result.extras.sub2 != nil {
                print(result.extras.sub2 ?? "")
                queriesDict["sub2"] = result.extras.sub2
            }
            
            if result.extras.sub2 != nil {
                print(result.extras.sub3 ?? "")
                queriesDict["sub3"] = result.extras.sub3
            }
        }
        return queriesDict
    }
}
