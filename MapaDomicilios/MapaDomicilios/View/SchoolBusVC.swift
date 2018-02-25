//
//  ViewController.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyHelpers


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
    var disposable = DisposeBag()
    fileprivate var viewModel = SchoolBusViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func rxBind(){
        /*self.collectionView.rx
         .setDelegate(self)
         .disposed(by: self.disposeBag)*/
        
        self.viewModel.getSchoolBuses()
            .subscribe { event in
                switch event {
                case let .next(response):
                    self.viewModel.schoolBus = response
                    self.viewModel.rx_SchoolBus.value = response.schoolBus
                case .error:
                    self.showOfflineAlert()
                case .completed:
                    return
                }
                
            }.disposed(by: self.viewModel.disposeBag)
        
        let dataSource = self.createDataSource()
        
//        self.viewModel.rx_SchoolBus
//            .asObservable()
//            .map(self.viewModel.getBusRoute)
//            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
//            .disposed(by: self.disposeBag)
        
        
        
        
        
    }

    func createDataSource()-> RxCollectionViewSectionedReloadDataSource<SectionSchoolBus>{
        let data = RxCollectionViewSectionedReloadDataSource<SectionSchoolBus>().configureCell { (dataSource: CollectionViewSectionedDataSource<SectionSchoolBus>, collectionView: UICollectionView, indexPath: IndexPath, item: Bus) in
            let cell: SchoolBusCollectionCell = collectionView.cellForClass(indexPath)
            cell.setData(bus: item)
            return cell
        return dataSource
    }
    
    func showOfflineAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("You are offline", comment: "You are offline"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        if !(self.navigationController!.visibleViewController!.isKind(of: UIAlertController.self)) {
            OperationQueue.main.addOperation {
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}

