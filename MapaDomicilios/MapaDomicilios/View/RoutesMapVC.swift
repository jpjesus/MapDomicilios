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
import GoogleMaps
import Kingfisher



class RoutesMapVC: UIViewController {
    
     var mapsView: GMSMapView!
    
    var viewModel:RoutesMapViewModel?
    private var rx_drawRouter = PublishSubject<Stop>()
    private var disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private var marker = GMSMarker()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popFadeAnimation()
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
        
    }

}


extension RoutesMapVC{
    
    func drawRoute(_ stop:Stop){
        let path = GMSMutablePath()
        if let  coordenades = stop.stops {
            for coord in coordenades {
                path.add(CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude))
            }
            createMarker(coordenades)
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
    
    func createMarker(_ coordenades:[Coordinates]){
        let camera = GMSCameraPosition.camera(withLatitude: (coordenades.first?.latitude)!, longitude: (coordenades.first?.longitude)!, zoom: 14.0)
        self.mapsView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: (coordenades.first?.latitude)!, longitude: (coordenades.first?.longitude)!)
        marker.map = mapsView
    }
}




extension RoutesMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        self.mapsView.isMyLocationEnabled = true
        self.mapsView.settings.myLocationButton = true
        self.mapsView.settings.zoomGestures = true
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapsView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}
