//
//  SettingsTableController.swift
//  funding
//
//  Created by Daniel Nzioka on 1/31/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController {
    
    @IBOutlet var budgetField: UITextField!
    @IBOutlet var timeSelector: UIDatePicker!
    @IBOutlet var touchIDToggle: UISwitch!
    
    let budgetConst = "budgetConstName"
    let timeConst = "timeConst"
    let touchIDConst = "switchKeyName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let defaults = UserDefaults.standard
        
        if let budgetFieldValue = defaults.string(forKey: budgetConst) {
            budgetField.text = budgetFieldValue
        }
        
        if let timePickerValue = defaults.string(forKey: timeConst) {
            timeSelector.date = timePickerValue.toDate(dateFormat: "HH:mm")
        }
        
        if (defaults.bool(forKey: touchIDConst)) {
            touchIDToggle.isOn = true
        } else {
            touchIDToggle.isOn = false
        }
        
        customize()
    }
    
    func customize() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        budgetField.inputAccessoryView = toolbar
    }
    
    @objc
    func doneBtnAction() {
        self.view.endEditing(true)
    }
    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.setValue(budgetField.text, forKey: budgetConst)
        defaults.setValue(timeSelector.date.toDateString(dateFormat: "HH:mm"), forKey: timeConst)
        defaults.setValue(touchIDToggle.isOn, forKey: touchIDConst)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveSettings()
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
