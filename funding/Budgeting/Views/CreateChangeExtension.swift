//
//  CreateChangeExtension.swift
//  funding
//
//  Created by Daniel Nzioka on 11/3/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

extension CreateChange {
    
    func enableCloseKeyboard() {
        
        addTapToCloseKeyboard()
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        noteTextTypeView.inputAccessoryView = toolbar
        noteTextAmountView.inputAccessoryView = toolbar
        noteTitleTextField.inputAccessoryView = toolbar
        
    }
    
    func customizeFields() {
    }
    
    func scheduleNotificationsFor(index: Int) {
        
    }
    
    @objc
    func doneBtnAction() {
        self.view.endEditing(true)
    }
    
    func addTapToCloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func customize() {
        
        notesLayer.layer.cornerRadius = 6
        notesLayer.layer.shadowRadius = 0.8
        notesLayer.layer.borderWidth = 1.0
        notesLayer.layer.borderColor = UIColor.lightGray.cgColor
        
        doneButtonLayer.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        doneButtonLayer.layer.cornerRadius = 12
        doneButtonLayer.layer.shadowRadius = 9
        doneButtonLayer.layer.borderWidth = 0.0
        
        datePickerLayer.layer.cornerRadius = 6
        datePickerLayer.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        datePickerLayer.layer.shadowRadius = 0.8
        datePickerLayer.layer.borderWidth = 1.0
        datePickerLayer.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
}
