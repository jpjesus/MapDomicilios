//
//  RoutesMapViewModel.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/25/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper
import GoogleMaps


class RoutesMapViewModel{
    
     var disposeBag = DisposeBag()
     var provider = MoyaProvider<BusAPI>()
     var stops:Bus?
    

    init() {
    }
    
    func getMapRoute(_ stopUrl:String)->Observable<Stop> {
        return provider.rx
            .request(BusAPI.mapRoutes(url: stopUrl))
            .asObservable()
            .mapObject(Stop.self)
    }
}
