//
//  Utils.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 21.12.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct Storyboard {
    static let gameViewController = "gameVC"
    static let quizViewController = "quizVC"
    static let winViewController = "winVC"
}

struct Consts {
    static let APPLE_APP_ID = "1536002227"
    static let ONESIGNAL_ID = "a7e60277-d981-4310-82f1-e790e23777a4"
    static let APPSFLYER_DEV_KEY = "Yd8HTCGPw8b4VDeBvrNqtd"
    static let METRICA_SDK_KEY = "7b9a2df8-dcef-47f6-b78a-abfc0b3c5b68"
    static let ORG_F = "oswn6tvtmztmokzwovqc"
}

struct ResultData {
    var key: String
    var sub1: String
    var sub2: String?
    var sub3: String?
    var source: String
}

struct Response: Decodable {
    var naming: String
    var deeplink: String
    var integration_version: String
    var organic: OrganicData
    var user: String
    var media_sources: [MediaSources]
}

struct OrganicData: Decodable {
    var org_status: String
    var org_key: String?
    var sub1: String?
    var sub2: String?
    var sub3: String?
}

struct MediaSources: Decodable {
    var source: String?
    var media_source: String
    var key: MediaSource
    var sub1: MediaSource
    var sub2: MediaSource
    var sub3: MediaSource
}

struct MediaSource: Decodable {
    var name: String
    var split: Bool
    var delimiter: String?
    var position: Int?
}

class Utils {
    
    func sendToServer(_ postString: String) {
        let urlStr = "https://tbraza.club/api/install_logs/create?conversionData=naming&appName=com.gb.luckyquizz&version=1"
        let url = URL(string: urlStr)
        guard let requestUrl = url else { print("Error: bad url"); return }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { print("Error posting data:\n \(error)"); return }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }.resume()
    }
    
    func getNData(mediaSources: [MediaSources], completion: (ResultData?) -> ()) {
        
        guard let dict: [String: Any] = UserDefaults.standard.object(forKey: "dataDict") as? [String : Any]
        else { completion(nil); return }
        print(dict)
        
        // for naming testing
//                let dict: [String: Any] = ["retargeting_conversion_type":"none",
//                                                 "orig_cost":"0.9",
//                                                 "af_ip":"85.26.241.188",
//                                                 "af_cost_currency":"USD",
//                                                 "is_first_launch":true,
//                                                 "af_click_lookback":"7d",
//                                                 "iscache":true,
//                                                 "click_time":"2020-12-12 17:13:41.728",
//                                                 "match_type":"id_matching",
//                                                 "campaign_id":"5fd4f0baebb932a5c6f71839",
//                                                 "game_id":"500057978",
//                                                 "install_time":"2020-12-13 09:54:39.922",
//                                                 "redirect":"false",
//                                                 "gamer_id":"580793b140edac597396b80755a2365928ce1a45e2df0dbfee59c3d97492f544590702c6fc68322704cf4d190e04bc54941fc9612adba2f6007b0e600ac7ae67c97f53a26837a127260fd500a1eebdfda01faadf65f580e3a9c47b0a",
//                                                 "af_ua":"Mozilla/5.0 (Linux; Android 10; SM-A115F Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/81.0.4044.138 Mobile Safari/537.36",
//                                                 "af_c_id":"5fd4f0baebb932a5c6f71839",
//                                                 "media_source":"unityads_int",
//                                                 "idfa":"8525ab92-ec44-449b-8703-ac118ad45000",
//                                                 "advertising_id":"8525ab92-ec44-449b-8703-ac118ad45000",
//                                                 "af_siteid":"26c1XQkGCQAO",
//                                                 "af_status":"Non-organic",
//                                                 "cost_cents_USD":"90",
//                                                 "af_ad_id":"5fd4f133f121c82dd9298da3",
//                                                 "af_adset":"kreo4",
//                                                 "af_cost_value":"0.90",
//                                                 "campaign":"6pts2sibb2tnag58yvg9:yaroslavFrootGardenRu",
//                                                 "af_cost_model":"cpi",
//                                                 "af_ad":"kreo4"
//                ]
        
        var key = ""
        var sub1 = ""
        var sub2 = ""
        var sub3 = ""
        var src = ""
        var isPresent = false
        
        for source in mediaSources {
            
            if source.media_source == dict["media_source"] as? String {
                isPresent = true
                
                key = getParamData(of: source.key, at: dict)
                sub1 = getParamData(of: source.sub1, at: dict)
                sub2 = getParamData(of: source.sub2, at: dict)
                sub3 = getParamData(of: source.sub3, at: dict)
                src = source.source ?? "none"
                
                let data = ResultData(key: key, sub1: sub1, sub2: sub2, sub3: sub3, source: src)
                completion(data)
            }
        }
        
        if !isPresent { completion(nil) }
    }
    
    func getParamData(of ss: MediaSource, at dict: [String:Any]) -> String {
        var res = ""
        
        if ss.split == true {
            let name = dict[ss.name] as? String ?? "none"
            let splited = name.components(separatedBy: ss.delimiter ?? "")
            let elem: String = splited[ss.position ?? 0]
            res = elem
            
        } else { res = dict[ss.name] as? String ?? "none" }
        
        return res
    }
    
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
    
    func formJsonStr(link: String) -> String {
        let v1 = link.components(separatedBy: "al_applink_data=")[1]
        let v2 = v1.removingPercentEncoding!
        let v3 = v2.components(separatedBy: "al_applink_data=")[1]
        let v4 = v3.components(separatedBy: "\",\"")[0]
        let v5 = v4.replacingOccurrences(of: "\\", with: "")
        return v5
    }
    
    func parseJSON(jsonString: String, completion: @escaping (InnerAppLinkData?) -> Void) {
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
    
    func getDData(link: String, completion: (ResultData?) -> ()) {
        
        if link == "" { completion(nil); return }
        let queries = getDParams(link: link)
        
        let linkData = ResultData(
            key: queries["key"] ?? "",
            sub1: queries["sub1"] ?? "",
            sub2: queries["sub2"] ?? nil,
            sub3: queries["sub3"] ?? nil,
            source: "fb")
        
        completion(linkData)
    }
    
    func getDParams(link: String) -> [String: String] {
        
        let jsonStr = formJsonStr(link: link)
        var queriesDict = [String: String]()
        
        parseJSON(jsonString: jsonStr) { result in
            guard let result = result else { print("Result is empty"); return }
            
            queriesDict["key"] = result.extras.key
            queriesDict["sub1"] = result.extras.sub1
            
            if result.extras.sub2 != nil { queriesDict["sub2"] = result.extras.sub2 }
            if result.extras.sub3 != nil { queriesDict["sub3"] = result.extras.sub3 }
        }
        return queriesDict
    }
}
