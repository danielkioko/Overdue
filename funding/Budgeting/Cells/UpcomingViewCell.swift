//
//  UpcomingViewCell.swift
//  funding
//
//  Created by Daniel Nzioka on 12/20/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class UpcomingViewCell: UICollectionViewCell {
    
    @IBOutlet var billLayer: UIView!
    @IBOutlet var billName: UILabel!
    @IBOutlet var billAmount: UILabel!
    @IBOutlet var billDueDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        billLayer.layer.cornerRadius = 10
        billLayer.layer.shadowColor = UIColor.black.cgColor
        billLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        billLayer.layer.shadowOpacity = 0.2
        billLayer.layer.shadowRadius = 10.0
        
        
    }

}
