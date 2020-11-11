//
//  Structs.swift
//  LuckyQuiz
//
//  Created by Mark Vais on 11.11.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import Foundation

struct Status {
    let source: String
    let user: Bool
    let media_sources: [MediaSource]
}

struct MediaSource {
    let source: String
    let media_source: String
    let key: MediaSourceData
    let sub1: MediaSourceData
    let sub2: MediaSourceData
    let sub3: MediaSourceData
}

struct MediaSourceData {
    let name: String
    let split: Bool
    let delimiter: String = ":"
    let position: Int = 0
}
