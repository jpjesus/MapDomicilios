//
//  BusAPI.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Moya

var apiURL = "https://api.myjson.com/bins/10yg1t"

enum BusAPI{
    case schoolBusses
}



extension BusAPI: TargetType{
    
    var baseURL: URL {
        guard let url = URL(string: apiURL) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .schoolBusses:
             return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .schoolBusses:
            return .get
        }
    }
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .schoolBusses:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
       return nil
    }
    
    
    
    
}
