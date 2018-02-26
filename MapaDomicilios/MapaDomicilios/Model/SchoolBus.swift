//
//  Bus.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Then
import ObjectMapper




struct  Bus:Mappable , Then {
    
    var id:Int = 0
    var name:String = ""
    var description:String? = ""
    var imgURL:String? = ""
    var busStops:Stop?
    var stopUrl:String? = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        imgURL <- map["img_url"]
        stopUrl <- map["stops_url"]
    }
    
}

final class SchoolBus:Mappable, Then{
    
    var  schoolBus:[Bus]?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        self.schoolBus <- map["school_buses"]
    }
    
    init() {
    }
}
