//
//  CreateChangeVC.swift
//  funding
//
//  Created by Daniel Nzioka on 10/21/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

class CreateChange: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextAmountView: UITextField!
    @IBOutlet weak var noteTextTypeView: UITextField!
    @IBOutlet weak var noteActualDate: UIDatePicker!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var noteIcon: UIImageView!
    @IBOutlet var notesLayer: UIView!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var doneButtonLayer: UIView!
    @IBOutlet var datePickerLayer: UIView!
    
    var gradientLayer = CAGradientLayer()
    
    var currentDate: String = ""
    var reminderDate: String = ""
    
    var importedResult:String = ""
    
    private(set) var changingReallySimpleNote : SimpleNote?

    var typeItems = ["Household", "Taxes", "Debits", "Other"]
    var typePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
        customize()
        noteActualDate.minimumDate = Date()
        
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
    
        selectType()
        
        if (noteTextTypeView.text == "") {
            noteIcon.image = UIImage(named: typeItems[0])
            noteTextTypeView.text = String(typeItems[0])
        } else {
            noteIcon.image = UIImage(named: noteTextTypeView.text!)
        }
        
        enableCloseKeyboard()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeItems.count
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        noteTextTypeView.text = typeItems[row]
        
        var i = 0
        while (i < typeItems.count) {
            
            if (i <= typeItems.count) {
                noteIcon.image = UIImage(named: typeItems[row])
            }
            
            i = i + 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeItems[row]
    }
    
    func selectType() {
        noteTextTypeView.inputView = typePicker
     }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if (noteTitleTextField.text == "" || noteTextAmountView.text == "") {
            let alert = UIAlertController(title: "Please, fill in all fields", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            if self.changingReallySimpleNote != nil {
                // change mode - change the item
                changeItem()
            } else {
                // create mode - create the item
                addItem()
                addNotification()
            }
        }
                
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : SimpleNote) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
    
    func addNotification() {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = noteTitleTextField.text!
        content.body = noteTextAmountView.text! + " Due Soon"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
            
    }
    
    private func addItem() -> Void {

        let note = SimpleNote(
            noteTitle:  noteTitleTextField.text!,
            amount:     noteTextAmountView.text!,
            notes:      notesText.text!,
            noteType:   noteTextTypeView.text!,
            actualDate: noteActualDate.date)
        
        NoteStorage.storage.addNote(noteToBeAdded: note)
        performSegue(withIdentifier: "backToMenu", sender: self)
    }

    private func changeItem() -> Void {
        // get changed note instance
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // change the note through note storage
            NoteStorage.storage.changeNote(
                
                noteToBeChanged: SimpleNote(
                    noteId:         changingReallySimpleNote.noteId,
                    noteTitle:      noteTitleTextField.text!,
                    notes:          notesText.text!,
                    amount:         noteTextAmountView.text!,
                    noteType:       noteTextTypeView.text!,
                    actualDate:     noteActualDate.date)
                
            )
            // navigate back to list of notes
            performSegue(withIdentifier: "backToMenu", sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK", style: .default ) { (_) in self.performSegue(withIdentifier: "backToMenu",
                                              sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }

}
