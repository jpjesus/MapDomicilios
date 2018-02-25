//
//  SchoolBusViewModel.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper

class SchoolBusViewModel {
    
    var disposeBag = DisposeBag()
    var rx_SchoolBus = Variable<SchoolBus?>(nil)
    var provider = MoyaProvider<BusAPI>()
    var schoolBus:SchoolBus?
    
    func getSchoolBuses() ->Observable<SchoolBus>{
        return provider.rx
            .request(BusAPI.schoolBusses)
            .retry(3)
            .debug()
            .asObservable()
            .mapObject(SchoolBus.self)
        
    }
    
    func getBusRoute(buses:SchoolBus?) -> [SectionSchoolBus] {
        var results:[SectionSchoolBus] = []
        if let buses = buses?.schoolBus {
            results.append(SectionSchoolBus (header: "", items: buses))
            return results
        }
        return results
    }
    
    
}
