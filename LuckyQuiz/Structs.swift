//
//  Structs.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

//
struct Consts {
    
    static let ORGANIC_FB    = "oswn6tvtmztmokzwovqc"
    static let ORGANIC_INAPP = "sl4nk4g3x0y8l6f8kiid"
    static let CLOAK_TOKEN   = "jCMs3QPM7gsT5D3V"
    
    static let APPSFLYER_DEV_KEY = "Yd8HTCGPw8b4VDeBvrNqtd"
    static let METRICA_SDK_KEY   = "7b9a2df8-dcef-47f6-b78a-abfc0b3c5b68"
}

//
struct Responce: Decodable {
    var source: String
    var user: String
    var media_sources: [MediaSources]
}

struct MediaSources: Decodable {
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
    var sub2: String?
    var sub3: String?
    var source: TrafficSource
}

enum TrafficSource: String {
    case FACEBOOK = "fb"
    case UNITY = "unity"
    case GOOGLE = "google"
}
