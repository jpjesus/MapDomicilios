//
//  Router.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/25/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps


protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
    
}

class SchoolBusRoute:Router {
    
    unowned var viewModel:SchoolBusViewModel
    
    init(viewModel: SchoolBusViewModel) {
        self.viewModel = viewModel
    }
    
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?) {
        
        guard let route = SchoolBusVC.Route(rawValue: routeID) else {
            return
        }
        switch  route {
        case .busRoute:
            let vc = RoutesMapVC()
            let vm = RoutesMapViewModel()
            vc.viewModel = vm
            vm.stops = parameters.flatMap{$0 as? Bus}
            context.navigationController?.do {
                $0.pushFadeAnimation(viewController: vc)
            }
        }
    }
}


