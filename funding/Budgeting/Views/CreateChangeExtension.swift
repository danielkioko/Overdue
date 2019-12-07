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
        
        
//        noteTitleTextField.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
//        noteTitleTextField.layer.borderWidth = 1.0
//        noteTitleTextField.layer.cornerRadius = 4
//
//        noteTextTypeView.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
//        noteTextTypeView.layer.borderWidth = 1.0
//        noteTextTypeView.layer.cornerRadius = 4
//
//        noteTextAmountView.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
//        noteTextAmountView.layer.borderWidth = 1.0
//        noteTextAmountView.layer.cornerRadius = 4
        
        doneButtonLayer.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        doneButtonLayer.layer.cornerRadius = 12
        doneButtonLayer.layer.shadowRadius = 9
        doneButtonLayer.layer.borderWidth = 0.0
        
        datePickerLayer.layer.cornerRadius = 4
        datePickerLayer.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        datePickerLayer.layer.shadowRadius = 0.8
        datePickerLayer.layer.borderWidth = 1.0
        datePickerLayer.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
