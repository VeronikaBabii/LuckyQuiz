//
//  DeeplinkParser.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 12.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

// trying to parse deeplink more beutifully

struct InnerAppLinkData: Decodable {
    var target_url: String
    var extras: Extras
}

struct Extras: Decodable {
    var key: String
    var sub1: String
    var sub2: String?
}

class DeeplinkParser {
    
    func formJsonStr(url: String) -> String {
        // 1 - receive deeplink
        print("\(url)\n")
        
        // 2 - split by al_applink_data=
        let outerApplink = url.components(separatedBy: "al_applink_data=")[1]
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
        
        // 6 - trying to get rid of bad symbols - /
        let withoutBadSymbols = withoutExtras.replacingOccurrences(of: "\\/", with: "")
        print("\(withoutBadSymbols)\n")
        
        return withoutBadSymbols
    }
    
    func decodeJSON(jsonString: String, completion: @escaping (InnerAppLinkData?) -> Void) {
        
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
    
    func usage() {
        let parse = DeeplinkParser()
        
        // main variants - get deeplink from api and parse it
        let url = "gbquiz://link?should_fallback=false&al_applink_data=%7B%22target_url%22%3A%22gbquiz%3A%5C%2F%5C%2Flink%3Fshould_fallback%3Dfalse%26al_applink_data%3D%7B%5C%22target_url%5C%22%3A%5C%22gbquiz%3A%5C%2F%5C%2Flink%5C%22%2C%5C%22extras%5C%22%3A%7B%5C%22key%5C%22%3A%5C%221234567890%5C%22%2C%5C%22sub1%5C%22%3A%5C%22blabla%5C%22%7D%7D%22%2C%22extras%22%3A%7B%22fb_app_id%22%3A354340085862913%7D%7D"
        
        let str: String = parse.formJsonStr(url: url)
        
        parse.decodeJSON(jsonString: str) { result in
            print(result?.extras.key ?? "no key")
            print(result?.extras.sub1 ?? "no sub1")
            print(result?.extras.sub2 ?? "no sub2")
        }
        
        // split on subs received link from formJsonStr method
        let string =
            """
            {\"target_url\":\"gbquiz:link\",\"extras\":{\"key\":\"1234567890\",\"sub1\":\"blabla\"}}
            """
        
        parse.decodeJSON(jsonString: string) { result in
            print(result?.extras.key ?? "no key")
            print(result?.extras.sub1 ?? "no sub1")
            print(result?.extras.sub2 ?? "no sub2")
        }
    }
}
