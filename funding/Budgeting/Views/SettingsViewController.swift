//
//  SettingsViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 12/11/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var budgetLayer: UIView!
    @IBOutlet var notificationsLayer: UIView!
    @IBOutlet var touchIDLayer: UIView!
    @IBOutlet var btnDone: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    func customize() {
        
        budgetLayer.layer.cornerRadius = 20
        budgetLayer.layer.shadowColor = UIColor.black.cgColor
        budgetLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        budgetLayer.layer.shadowOpacity = 0.2
        budgetLayer.layer.shadowRadius = 4.0
        
        notificationsLayer.layer.cornerRadius = 20
        notificationsLayer.layer.shadowColor = UIColor.black.cgColor
        notificationsLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        notificationsLayer.layer.shadowOpacity = 0.2
        notificationsLayer.layer.shadowRadius = 4.0
        
        touchIDLayer.layer.cornerRadius = 20
        touchIDLayer.layer.shadowColor = UIColor.black.cgColor
        touchIDLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        touchIDLayer.layer.shadowOpacity = 0.2
        touchIDLayer.layer.shadowRadius = 4.0
        
        btnDone.layer.cornerRadius = 20
        btnDone.layer.shadowColor = UIColor.black.cgColor
        btnDone.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        btnDone.layer.shadowOpacity = 0.2
        btnDone.layer.shadowRadius = 4.0
        
    }
    
}
