//
//  Structs.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct Consts {
    static let ORGANIC_FB    = "oswn6tvtmztmokzwovqc"
    static let ORGANIC_INAPP = "sl4nk4g3x0y8l6f8kiid"
    //static let CLOAK_TOKEN   = "jCMs3QPM7gsT5D3V"
    
    static let APPLE_APP_ID = "1536002227" 
    static let FB_APP_ID    = "354340085862913"
    static let ONESIGNAL_ID = "a7e60277-d981-4310-82f1-e790e23777a4"
    
    static let APPSFLYER_DEV_KEY = "Yd8HTCGPw8b4VDeBvrNqtd"
    
    static let METRICA_SDK_KEY      = "7b9a2df8-dcef-47f6-b78a-abfc0b3c5b68"
    static let METRICA_POST_API_KEY = "bb299571-92d7-4e90-a7e9-c30742d99d35"
    static let METRICA_APP_ID       = "3758374"

}

// for cloak responce parsing
struct Responce: Decodable {
    var naming: String
    var deeplink: String
    var organic: OrganicData
    var user: String
    var media_sources: [MediaSources]
    var integration_version: String
}

struct OrganicData: Decodable {
    var org_status: String
    var org_key: String
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

// for Deeplink/Naming/Organic result data
struct ResultData {
    var key: String
    var sub1: String
    var sub2: String?
    var sub3: String?
    var source: String
}
