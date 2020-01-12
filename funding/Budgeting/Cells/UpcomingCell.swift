//
//  UpcomingCell.swift
//  funding
//
//  Created by Daniel Nzioka on 1/11/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import UIKit
import Foundation

class UpcomingCell: UICollectionViewCell {
    
    @IBOutlet weak var billLayer: UIView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billAmount: UILabel!
    @IBOutlet weak var billDueDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        billLayer.layer.cornerRadius = 10
        billLayer.layer.shadowColor = UIColor.black.cgColor
        billLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        billLayer.layer.shadowOpacity = 0.2
        billLayer.layer.shadowRadius = 10.0
        
        
    }

}

