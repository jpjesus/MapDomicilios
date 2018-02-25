//
//  SchoolBusCollectionCell.swift
//  MapaDomicilios
//
//  Created by Jesus on 2/24/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import Foundation
import Kingfisher

class SchoolBusCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var schoolBus:Bus?
    
    override func awakeFromNib() {
    }
    
    func setData(bus:Bus) {
        self.schoolBus = bus
        self.titleLabel.text = schoolBus?.name
        self.subTitle.text = schoolBus?.description
        self.img.kf.indicatorType = .activity
        guard let img = schoolBus?.imgURL else {return}
        let url = URL(string: img)
        self.img.kf.setImage(with: url)
    }
    
}



