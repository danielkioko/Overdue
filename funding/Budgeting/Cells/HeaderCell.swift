//
//  HeaderCell.swift
//  funding
//
//  Created by Daniel Nzioka on 1/30/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var remaining: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(date)
        addSubview(total)
        addSubview(remaining)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
