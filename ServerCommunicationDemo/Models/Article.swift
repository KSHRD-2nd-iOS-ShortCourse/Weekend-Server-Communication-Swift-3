//
//  Book.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/15/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import Foundation
import ObjectMapper

class Article: BaseModel {
    var id: Int?
    var title : String?
    var description : String?
    var createdDate : String?
    var author : [String: Any]?
    var status : String?
    var category : [String: Any]?
    var image : String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["DATA.ID"]
        title <- map["DATA.TITLE"]
        description <- map["DATA.DESCRIPTION"]
        createdDate <- map["DATA.CREATED_DATE"]
        author <- map["DATA.AUTHOR"]
        status <- map["DATA.STATUS"]
        category <- map["DATA.CATEGORY"]
        image <- map["DATA.IMAGE"]
    }
}
