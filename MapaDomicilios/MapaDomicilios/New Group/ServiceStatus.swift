//
//  ServiceStatus.swift
//  MapaDomicilios
//
//  Created by Jesus Parada on 2/26/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation


enum ServiceStatus: Int, Error {
    case notAsigned
    case undefined
    case ok
    case failConnection
    case failValidation
    case failAuthentication
    case failParser
    case failAuthenticationLogin
    case serverError
    case timeOut
}


func serviceStatus(_ code: Int) -> ServiceStatus {
    switch code {
    case 200, 201, 202:
        return .ok
    case 401, -1012:
        return .failAuthentication
    case 500, 502, 800:
        return .serverError
    case 404, 412:
        return .failValidation
    case -1009, -1004, -1001, -1003, -1005:
        return .failConnection
    case 400:
        return .failAuthenticationLogin
    case 504:
        return .timeOut
    default:
        return .undefined
    }
}


