//
//  RoutesMapVC.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/25/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import Async
import GoogleMaps



class RoutesMapVC: UIViewController {
    
    var mapsView: GMSMapView!
    
    var viewModel:RoutesMapViewModel?
    private var rx_drawRouter = PublishSubject<Stop>()
    var disposeBag = DisposeBag()
    var stops:Bus?
    let locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Bus Route"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.setMap()
        rxBind()
    }
    
    func rxBind(){
        guard let stop = self.viewModel?.stops?.stopUrl else {return}
        self.viewModel?.getMapRoute(stop)
            .subscribe { event in
                switch event {
                case let .next(response):
                    self.rx_drawRouter.onNext(response)
                case .error:
                    return
                case .completed:
                    return
                }
            }.disposed(by: (self.viewModel?.disposeBag)!)
        
        rx_drawRouter.asObserver()
            .subscribe(onNext:{ [unowned self ] stop in
                self.drawRoute(stop)
            }).disposed(by: self.disposeBag)
        
        navigationController?.navigationItem.backBarButtonItem?.rx
            .tap
            .subscribe(onNext:{ _ in
                self.navigationController?.popFadeAnimation()
            }).disposed(by: self.disposeBag)
    }
    
    
    
}


extension RoutesMapVC{
    
    func drawRoute(_ stop:Stop){
        let path = GMSMutablePath()
        if let  coordenades = stop.stops {
            let camera = GMSCameraPosition.camera(withLatitude: (coordenades.first?.latitude)!, longitude: (coordenades.first?.longitude)!, zoom: 12.0)
            self.mapsView.camera = camera
            for coord in coordenades {
                path.add(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
            }
            let lineRoute = GMSPolyline(path: path)
            lineRoute.strokeWidth = 5
            lineRoute.strokeColor = .blue
            lineRoute.map = mapsView
        }
    }
    func setMap(){
            let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
            self.mapsView = GMSMapView.map(withFrame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height), camera: camera)
            self.view.addSubview(self.mapsView)
        
    }
}


extension RoutesMapVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        //marker.position = coordinate
    }
}

extension RoutesMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapsView.isMyLocationEnabled = true
        mapsView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapsView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}
