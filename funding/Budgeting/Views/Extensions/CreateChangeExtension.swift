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
    
    @objc
    func doneBtnAction() {
        self.view.endEditing(true)
    }
    
    func addTapToCloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func customize() {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(CreateChange.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateTextView.inputView = datePicker
        
        button.isSelected = false
                
        noteTextAmountView.delegate = self as? UITextFieldDelegate
        typePicker.delegate = self
        
        let changingReallySimpleNote = self.changingReallySimpleNote
        noteTextAmountView.text = changingReallySimpleNote?.amount.currencyFormatting()
        noteTextTypeView.text = changingReallySimpleNote?.noteType
        noteTitleTextField.text = changingReallySimpleNote?.noteTitle

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if importedResult != "0" {
            noteTextAmountView.text = importedResult
        }

        let titlePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 34))
        let amountPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 34))
        let typePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 34))
        
        button.layer.cornerRadius = 10
        
        noteTitleTextField.leftView = titlePaddingView
        noteTextAmountView.leftView = amountPaddingView
        noteTextTypeView.leftView = typePaddingView
        
        noteTitleTextField.layer.borderWidth = 2
        noteTitleTextField.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        noteTitleTextField.layer.cornerRadius = 2
        noteTitleTextField.layer.opacity = 0.8
        
        noteTextAmountView.layer.borderWidth = 2
        noteTextAmountView.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        noteTextAmountView.layer.cornerRadius = 2
        noteTextAmountView.layer.opacity = 0.8
        
        noteTextTypeView.layer.borderWidth = 2
        noteTextTypeView.layer.borderColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        noteTextTypeView.layer.cornerRadius = 2
        noteTextTypeView.layer.opacity = 0.8
        
        notesLayer.layer.borderWidth = 2
        notesLayer.layer.borderColor = #colorLiteral(red: 0.1568627451, green: 0.2078431373, blue: 0.3490196078, alpha: 1)
        notesLayer.layer.cornerRadius = 2
        notesLayer.layer.opacity = 0.8
        
        noteTitleTextField.leftViewMode = UITextField.ViewMode.always
        noteTextAmountView.leftViewMode = UITextField.ViewMode.always
        noteTextTypeView.leftViewMode = UITextField.ViewMode.always
        
        doneButtonLayer.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2352941176, blue: 0.4470588235, alpha: 1)
        doneButtonLayer.layer.cornerRadius = 12
        doneButtonLayer.layer.shadowRadius = 9
        doneButtonLayer.layer.borderWidth = 0.0
        
        if (noteTextTypeView.text == "") {
            noteIcon.image = UIImage(named: typeItems[0])
            noteTextTypeView.text = String(typeItems[0])
        } else {
            noteIcon.image = UIImage(named: noteTextTypeView.text!)
        }
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dateTextView.text = formatter.string(from: sender.date)
    }
    
}

extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}
