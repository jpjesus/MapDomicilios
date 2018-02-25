//
//  Stop.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Then
import ObjectMapper

struct Coordinates:Mappable,Then{
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
    }
}

final class Stop:Mappable,Then{
    var stops:[Coordinates]?
    var estimatedTime:Int = 0
    var retryTime:Int = 0
    init?(map: Map) { }
    
    func mapping(map: Map) {
        self.stops <- map["stops"]
        self.estimatedTime <- map["estimated_time_milliseconds"]
        self.retryTime <- map["retry_time_milliseconds"]
    }
    
    init() {
    }
    
}

