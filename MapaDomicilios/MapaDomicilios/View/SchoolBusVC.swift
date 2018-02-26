//
//  ViewController.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyHelpers
import SwiftSpinner



struct SectionSchoolBus {
    var header: String
    var items: [Item]
}

extension SectionSchoolBus: SectionModelType {
    typealias Item = Bus
    
    init(original: SectionSchoolBus, items: [Item]) {
        self = original
        self.items = items
    }
}


class SchoolBusVC: UIViewController {
    
    enum Route: String {
        case busRoute
    }
    
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.do{
                $0.showsVerticalScrollIndicator = false
                $0 <= SchoolBusCollectionCell.self
            }
        }
    }
    
    //vars
    var disposeBag = DisposeBag()
    fileprivate var viewModel = SchoolBusViewModel()
    var router:Router!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()
        router = SchoolBusRoute(viewModel: viewModel)
    }
    
    
    func rxBind(){
        SwiftSpinner.show("Loading bus routes")
        self.viewModel.getSchoolBuses()
            .subscribe { event in
                switch event {
                case let .next(response):
                    self.viewModel.schoolBus = response
                    self.viewModel.rx_SchoolBus.value = response
                    SwiftSpinner.hide()
                case .error:
                    SwiftSpinner.hide()
                    self.showOfflineAlert()
                case .completed:
                    return
                }
                
            }.disposed(by: self.viewModel.disposeBag)
        
        let dataSource = self.createDataSource()
        
        self.viewModel.rx_SchoolBus.asObservable()
            .map(self.viewModel.getBusRoute)
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by:self.viewModel.disposeBag)
        
        self.collectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx
            .modelSelected(Bus.self)
            .subscribe(onNext: { [unowned self] schoolBus in
                self.goTo(schoolBus)
            }).disposed(by: self.disposeBag)
        
    }
    
    func goTo(_ route:Bus) {
        router.route(to: Route.busRoute.rawValue, from: self,parameters: route)
    }
}

extension SchoolBusVC {
    func createDataSource()-> RxCollectionViewSectionedReloadDataSource<SectionSchoolBus>{
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionSchoolBus>(configureCell:{ (dataSource: CollectionViewSectionedDataSource<SectionSchoolBus>, collectionView: UICollectionView, indexPath: IndexPath, item: Bus) in
            let cell: SchoolBusCollectionCell = collectionView.cellForClass(indexPath)
            cell.setData(bus: item)
            return cell
        })
        return dataSource
        
    }
    
    func showOfflineAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("You are offline", comment: "You are offline"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        if let navigation = self.navigationController?.visibleViewController {
        if !(navigation.isKind(of: UIAlertController.self)) {
            OperationQueue.main.addOperation {
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }
        }
        }
    }
    
}


extension SchoolBusVC :UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.contentSize.width, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right:0)
    }
    
    
    
}

