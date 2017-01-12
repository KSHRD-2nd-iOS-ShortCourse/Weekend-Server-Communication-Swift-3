//
//  DataManager.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/18/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import Foundation

struct DataManager {
    struct Url {
        // Define url
        static let BASE = "http://120.136.24.174:15050/v1/api/"
        static let AUTH = BASE + "authentication"
        static let USER = BASE + "users"
        static let ARTICLE = BASE + "articles"
        static let FILE = BASE + "uploadfile/single"
    }
    
    // Define header
    static let HEADERS = [
        "Authorization" : "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
        "Content-Type" : "application/json",
        "Accept" : "application/json"
    ]
}




