//
//  BaseModel.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 1/12/17.
//  Copyright © 2017 Kokpheng. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel : Mappable {
    
    var code : String?
    var message : String?
    
    required init?(map: Map) { }
    
    // Mappable
    func mapping(map: Map) {
        code <- map["CODE"]
        message <- map["MESSAGE"]
    }

}
