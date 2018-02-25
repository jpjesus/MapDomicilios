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
    var rx_SchoolBus = Variable<[Bus]?>([])
    var provider = MoyaProvider<BusAPI>()
    var schoolBus:SchoolBus?
    
    func getSchoolBuses() ->Observable<SchoolBus>{
        return provider.rx
            .request(BusAPI.schoolBusses)
            .debug()
            .asObservable()
            .mapObject(SchoolBus.self)
        
    }
    
    func getBusRoute(_ buses:SchoolBus) -> SectionSchoolBus {

        if let buses = buses.schoolBus {
            return SectionSchoolBus (header: "", items: buses)
        }
        return SectionSchoolBus(header:"", items: [])
    }
    
}

    

