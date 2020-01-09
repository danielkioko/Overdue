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
    
    let budgetConst = "budgetConstName"
    let timeConst = "timeConst"
    let touchIDConst = "switchKeyName"
    
    @IBOutlet var budgetField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var touchIDSwitch: UISwitch!
    
    @IBOutlet var budgetLayer: UIView!
    @IBOutlet var notificationsLayer: UIView!
    @IBOutlet var touchIDLayer: UIView!
    @IBOutlet var btnDone: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let budgetFieldValue = defaults.string(forKey: budgetConst) {
            budgetField.text = budgetFieldValue
        }
        
        if let timePickerValue = defaults.string(forKey: timeConst) {
            timePicker.date = timePickerValue.toDate(dateFormat: "HH:mm")
        }
        
        if (defaults.bool(forKey: touchIDConst)) {
            touchIDSwitch.isOn = true
        } else {
            touchIDSwitch.isOn = false
        }
        
        customize()
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue(budgetField.text, forKey: budgetConst)
        defaults.setValue(timePicker.date.toDateString(dateFormat: "HH:mm"), forKey: timeConst)
        defaults.setValue(touchIDSwitch.isOn, forKey: touchIDConst)
        
        let vc = MainViewController()
        vc.calculateTotal()
        vc.leCollectionView.reloadData()
        
    }
    
    func customize() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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

extension Date
{
    func toDateString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String
{
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
}
