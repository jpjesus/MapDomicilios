//
//  NavigationController+Animations.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/25/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit


extension UINavigationController {
    func pushFadeAnimation(viewController: UIViewController) {
        let transition = CATransition().then {
            $0.type = kCATransitionFade
            $0.duration = 0.5
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func popFadeAnimation() {
        let transition = CATransition().then {
            $0.type = kCATransitionFade
            $0.duration = 0.5
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
}
