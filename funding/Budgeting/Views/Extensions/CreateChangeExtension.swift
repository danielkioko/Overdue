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
    
    func configureView() {
       if let detail = detailsToFill {
        
           if let topicLabel = noteTitleTextField,
              let datePicker = noteActualDate,
              let typeLabel = noteTextTypeView,
              let notesView = notesText,
              let textView = noteTextAmountView,
              let toggle = reOccurringToggle {
               topicLabel.text = detail.noteTitle
            typeLabel.text = detail.noteType
            datePicker.date = detail.actualDate
            textView.text = detail.amount.currencyFormatting()
            notesView.text = detail.notes
            toggle.isOn = detail.recurring
                
           }
       }
    }
    
    func customize() {
        
        if (detailsToFill != nil) {
            configureView()
        }
        
        reOccurringToggle.isSelected = false
        
        cardLayer.layer.cornerRadius = 20
        cardLayer.layer.shadowColor = UIColor.black.cgColor
        cardLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cardLayer.layer.shadowOpacity = 0.2
        cardLayer.layer.shadowRadius = 4.0
        
        datePickerLayer.layer.cornerRadius = 20
        datePickerLayer.layer.shadowColor = UIColor.black.cgColor
        datePickerLayer.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        datePickerLayer.layer.shadowOpacity = 0.2
        datePickerLayer.layer.shadowRadius = 4.0
                
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
        
        reOccurringToggle.layer.cornerRadius = 10
        
        noteTitleTextField.leftView = titlePaddingView
        noteTextAmountView.leftView = amountPaddingView
        noteTextTypeView.leftView = typePaddingView
        
        noteTitleTextField.layer.cornerRadius = 10
        noteTitleTextField.layer.opacity = 0.8
        
        noteTextAmountView.layer.cornerRadius = 10
        noteTextAmountView.layer.opacity = 0.8
        
        noteTextTypeView.layer.cornerRadius = 10
        noteTextTypeView.layer.opacity = 0.8
        
        notesLayer.layer.cornerRadius = 10
        notesLayer.layer.opacity = 0.8
        
        noteTitleTextField.leftViewMode = UITextField.ViewMode.always
        noteTextAmountView.leftViewMode = UITextField.ViewMode.always
        noteTextTypeView.leftViewMode = UITextField.ViewMode.always
        
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
