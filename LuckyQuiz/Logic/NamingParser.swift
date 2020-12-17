//
//  NamingParser.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 12.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

class NamingParser {
    
    // NewLogic helper
    func getDataFromNaming(mediaSources: [MediaSources], completion: (ResultData?) -> ()) {
        
        // get naming from appsflyer here and write to dict
        
        
        
        // if naming is empty - return from func and namingData is nil
        
        //        if naming == "" {
        //            print("No naming - going further")
        //            completion(nil)
        //            return
        //        }
        
        // naming not empty - process it
        
        let namingDict: [String: Any] = ["retargeting_conversion_type":"none",
                                         "orig_cost":"0.9",
                                         "af_ip":"85.26.241.188",
                                         "af_cost_currency":"USD",
                                         "is_first_launch":true,
                                         "af_click_lookback":"7d",
                                         "iscache":true,
                                         "click_time":"2020-12-12 17:13:41.728",
                                         "match_type":"id_matching",
                                         "campaign_id":"5fd4f0baebb932a5c6f71839",
                                         "game_id":"500057978",
                                         "install_time":"2020-12-13 09:54:39.922",
                                         "redirect":"false",
                                         "gamer_id":"580793b140edac597396b80755a2365928ce1a45e2df0dbfee59c3d97492f544590702c6fc68322704cf4d190e04bc54941fc9612adba2f6007b0e600ac7ae67c97f53a26837a127260fd500a1eebdfda01faadf65f580e3a9c47b0a",
                                         "af_ua":"Mozilla/5.0 (Linux; Android 10; SM-A115F Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/81.0.4044.138 Mobile Safari/537.36",
                                         "af_c_id":"5fd4f0baebb932a5c6f71839",
                                         "media_source":"unityads_int",
                                         "idfa":"8525ab92-ec44-449b-8703-ac118ad45000",
                                         "advertising_id":"8525ab92-ec44-449b-8703-ac118ad45000",
                                         "af_siteid":"26c1XQkGCQAO",
                                         "af_status":"Non-organic",
                                         "cost_cents_USD":"90",
                                         "af_ad_id":"5fd4f133f121c82dd9298da3",
                                         "af_adset":"kreo4",
                                         "af_cost_value":"0.90",
                                         "campaign":"6pts2sibb2tnag58yvg9:yaroslavFrootGardenRu",
                                         "af_cost_model":"cpi",
                                         "af_ad":"kreo4"
        ]
        
        var key = ""
        var sub1 = ""
        var sub2 = ""
        var sub3 = ""
        
        // check wheter naming source is the same to one of sources in cloak media_sources
        for source in mediaSources {
            if source.media_source == namingDict["media_source"] as? String {
                print(source.media_source)
                
                key = getNamingParamData(of: source.key, at: namingDict)
                sub1 = getNamingParamData(of: source.sub1, at: namingDict)
                sub2 = getNamingParamData(of: source.sub2, at: namingDict)
                sub3 = getNamingParamData(of: source.sub3, at: namingDict)
                
            }
        }
        
        let namingData = ResultData(
            key: key,
            sub1: sub1,
            sub2: sub2,
            sub3: sub3,
            source: TrafficSource.FACEBOOK)
        
        completion(namingData)
    }
    
    func getNamingParamData(of ss: MediaSource, at namingDict: [String:Any]) -> String {
        
        // let ss = source.key or source.sub1 ..
        var res = ""
        
        if ss.split == true {
            let cloakName = ss.name
            let namingName = namingDict[cloakName] as! String
            
            let splitBy = ss.delimiter ?? "" // if we have a split, so that del and pos
            let pos = ss.position ?? 0
            
            let splited = namingName.components(separatedBy: splitBy)
            let elem: String = splited[pos]
            res = elem
            print(res)
            
        } else { // split is false - get all param value
            let cloakName = ss.name
            res = namingDict[cloakName] as! String
            print(res)
        }
        
        return res
    }
    
}
