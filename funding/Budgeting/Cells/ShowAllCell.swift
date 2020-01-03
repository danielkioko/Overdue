//
//  ShowAllCell.swift
//  funding
//
//  Created by Daniel Nzioka on 1/2/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import UIKit

class ShowAllCell: UICollectionViewCell {
    
    @IBOutlet var btnLayer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnLayer.layer.cornerRadius = 10
        btnLayer.layer.shadowColor = UIColor.black.cgColor
        btnLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        btnLayer.layer.shadowOpacity = 0.2
        btnLayer.layer.shadowRadius = 10.0
    }

}
