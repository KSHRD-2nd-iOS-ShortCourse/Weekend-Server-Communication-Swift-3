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
        static let BASE = "http://120.136.24.174:15050/"
        static let AUTH = BASE + "v1/api/authentication"
        static let USER = BASE + "v1/api/users"
        static let ARTICLE = BASE + "v1/api/articles"
    }
    
    // Define header
    static let HEADERS = [
        "Authorization" : "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
        "Content-Type" : "application/json",
        "Accept" : "application/json"
    ]
}




