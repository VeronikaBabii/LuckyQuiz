//
//  Utils.swift
//  WebViewDemo
//
//  Created by Mark Vais on 15.09.2020.
//  Copyright © 2020 Mark Vais. All rights reserved.
//

import UIKit
import FBSDKCoreKit

struct Utils {
    
    // MARK: - old - parsing deeplink ugly way 
    func getQueriesFromDeeplink(_ url: String) -> [String: String] {
        
        var queryDict: [String:String] = ["":""]
        
        if url != "" {
            
            // get al_applink_data data
            let applink = url.components(separatedBy: "al_applink_data=")[1]
            print("\(applink)\n")
            
            // decode
            let decodedApplink = applink.removingPercentEncoding!
            print("\(decodedApplink)\n")
            
            let decodedApplink1 = decodedApplink.replacingOccurrences(of: "\\", with: "")
            print("\(decodedApplink1)\n")
            
            // get extras value
            let paramsStr = decodedApplink1.components(separatedBy: ",\"extras\":{")[1].replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "").dropLast().dropLast()
            
            // check if extras is empty
            if paramsStr != "" {
                
                //print("\(paramsStr)\n")
                
                // split string into array of strings
                let paramsArray = paramsStr.components(separatedBy: ",")
                print("\(paramsArray)\n")
                
                // filter params only with 'key' or 'sub' chars
                let filteredParamsArray = paramsArray.filter { $0.contains("sub") || $0.contains("key")}
                
                if filteredParamsArray != [] {
                    print("\(filteredParamsArray)\n")
                    
                    // add params to queries dictionary
                    for param in filteredParamsArray {
                        queryDict["\(param.components(separatedBy: ":")[0])"] = param.components(separatedBy: ":")[1]
                    }
                    print("\(queryDict)\n")
                    
                } else { print("No subs \n") }
            } else { print("Extras is empty \n") }
        } else { print("Deeplink url is empty") }
        return queryDict
    }
    
    // MARK: - form url from queries params
    func formUrlToShow(_ queries: Array<(key: String, value: String)>) -> String {
        
        var urlToShow = "https://egame.site/click.php"
        
        for (index, query) in queries.enumerated() {
            
            if (index == 0) { urlToShow += "?" } else { urlToShow += "&" }
            
            urlToShow += "\(query.key)=\(query.value)"
        }
        //print("\(urlToShow)\n")
        return urlToShow
    }
    
    // MARK: -
    // add hash (unique id) to consts
    func getUniqueID() -> String {
        let UNIQUE_ID = randomID()
        UserDefaults.standard.set(UNIQUE_ID, forKey: "UNIQUE_ID")
        return UNIQUE_ID
    }
    
    // getUniqueID helper
    func randomID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let id = String((0..<20).map{ _ in letters.randomElement()! })
        return id
    }
    
    // MARK: - make request to the server to check whether to show web view agreement
    func checkAgreementStatus() {
        
        //let bundleId = Bundle.main.bundleIdentifier
        //let url = URL(string: "https://integr-testing.site/checker/\(bundleId!)")!
        
        let url = URL(string: "https://integr-testing.site/checker/?token=jCMs3QPM7gsT5D3V")!
        print("\(url)\n")
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let fbCheckerOuput = String(data: data, encoding: .utf8)!
            print("\n\(fbCheckerOuput)\n")
            
            let SHOW_AGREEMENT = "false" // for game testing
            UserDefaults.standard.set(SHOW_AGREEMENT, forKey: "SHOW_AGREEMENT")
            
            // clear values from UserDefaults
            UserDefaults.standard.set(nil, forKey: "SHOW_WEB")
            UserDefaults.standard.set(nil, forKey: "SHOW_GAME")
            
            if SHOW_AGREEMENT == "true" {
                UserDefaults.standard.set("true", forKey: "SHOW_WEB")
                print("to show web")
                
            } else if SHOW_AGREEMENT == "false" {
                UserDefaults.standard.set("true", forKey: "SHOW_GAME")
                print("to show game")
                
            } else { print("Error getting response from the server") }
        }
        task.resume()
    }
    
    // MARK: - other 
    func printUserDefaults() {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        print("\n")
    }
    
    //MARK: -
    
    func getQueriesFromNaming(_ url: String) -> [String: String] {
        return ["":""]
    }
}


