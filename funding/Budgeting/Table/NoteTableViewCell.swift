//
//  NoteTableViewCell.swift
//  funding
//
//  Created by Daniel Nzioka on 10/21/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    private(set) var noteTitle: String = ""
    private(set) var amount: String = ""
    private(set) var noteDate: String = ""
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var cellBar: UIView!
    @IBOutlet var noteTitleLabel: UILabel!
    @IBOutlet var noteAmountLabel: UILabel!
    @IBOutlet var daysLeftToDueDateLabel: UILabel!
    @IBOutlet var noteDateLabel: UILabel!
    
}
