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
    case mapRoutes(url:String)
}


extension BusAPI: TargetType{
    
    var baseURL: URL {
        switch self {
        case let .mapRoutes(url: routeUrl):
            guard let url = URL(string: routeUrl) else { fatalError("baseURL could not be configured") }
            return url
        default:
            guard let url = URL(string: apiURL) else { fatalError("baseURL could not be configured") }
            return url
        }
        
    }
    
    var path: String {
        switch self {
        case .schoolBusses,.mapRoutes:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .schoolBusses,.mapRoutes:
            return .get
        }
    }
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .schoolBusses,.mapRoutes:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
