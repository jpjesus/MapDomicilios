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
    var disposeBag = DisposeBag()
    fileprivate var viewModel = SchoolBusViewModel()
    fileprivate let activityIndicator = ActivityIndicator()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()
    }

    
    func rxBind(){

        self.viewModel.getSchoolBuses()
            .subscribe { event in
                switch event {
                case let .next(response):
                    self.viewModel.schoolBus = response
                    self.viewModel.rx_SchoolBus.value = response
                case .error:
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
    
    func setupReach(){
        
    }
    
}


extension SchoolBusVC :UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.contentSize.width, height: 150)
        
    }
    
    
    
}

