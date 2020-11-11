//
//  CreateChangeVC.swift
//  funding
//
//  Created by Daniel Nzioka on 10/21/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

class CreateChange: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextAmountView: UITextField!
    //@IBOutlet weak var noteTextTypeView: UITextField!
    @IBOutlet weak var noteActualDate: UIDatePicker!
    @IBOutlet weak var notesText: UITextView!
    
    @IBOutlet var notesLayer: UIView!
    @IBOutlet var cardLayer: UIView!
    @IBOutlet var reOccurringToggle: UISwitch!
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var datePickerLayer: UIView!
    
    var gradientLayer = CAGradientLayer()
    
    var currentDate: String = ""
    var reminderDate: String = ""
    var isRecurring: Bool = false
    
    var importedResult:String = ""
    
    private(set) var changingReallySimpleNote : SimpleNote?

    var typeItems = ["Household", "Taxes", "Debits", "Other"]
    var typePicker = UIPickerView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customize()
        enableCloseKeyboard()
        
        doneButton.layer.cornerRadius = 5
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        doneButton.layer.shadowOpacity = 0.2
        doneButton.layer.shadowRadius = 4.0
        
        exitButton.layer.cornerRadius = 5
        exitButton.layer.shadowColor = UIColor.black.cgColor
        exitButton.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        exitButton.layer.shadowOpacity = 0.2
        exitButton.layer.shadowRadius = 4.0
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
        if (changingReallySimpleNote != nil) {
            noteTitleTextField.text = changingReallySimpleNote!.noteTitle
            noteActualDate.date = changingReallySimpleNote!.actualDate
            noteTextAmountView.text = changingReallySimpleNote!.amount
            notesText.text = changingReallySimpleNote!.notes
            reOccurringToggle.isOn = changingReallySimpleNote!.recurring
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
                self.dismiss(animated: true, completion: nil)
            } else {
                // create mode - create the item
                addItem()
                addNotification()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func exitButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : SimpleNote) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
    
    func addNotification() {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        let markAsPaidAction = UNNotificationAction(
            identifier: "paid",
            title: "Paid",
            options: [])
        
        let ignoreAction = UNNotificationAction(
        identifier: "ignore",
        title: "Ignore",
        options: [])
        
        let alarmCategory = UNNotificationCategory(
            identifier: "alarm",
            actions: [markAsPaidAction, ignoreAction],
            intentIdentifiers: [],
            options: [])
        
        center.setNotificationCategories([alarmCategory])
        
        content.title = noteTitleTextField.text!
        content.body = noteTextAmountView.text! + " Due Soon"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let dateInSettings = UserDefaults.standard.string(forKey: "timeConst")
        let time = dateInSettings?.toDate(dateFormat: "HH:mm")
        
        let calendar = Calendar.current
        let heure = calendar.component(.hour, from: time ?? "09".toDate(dateFormat: "HH"))
        let minuite = calendar.component(.minute, from: time ?? "00".toDate(dateFormat: "mm"))
        
        var dateComponents = DateComponents()
        dateComponents.hour = heure
        dateComponents.minute = minuite
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    
    }
    
    func stringToDate(dateString: String) -> Date {
        let date = dateString.toDate()
        return date!
    }
    
    private func addItem() -> Void {

        let note = SimpleNote(
            noteTitle:  noteTitleTextField.text!,
            amount:     noteTextAmountView.text!,
            notes:      notesText.text!,
            actualDate: noteActualDate.date,
            recurring:  reOccurringToggle.isOn,
            paid:       true)
        
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
                    actualDate:     noteActualDate.date,
                    recurring:      reOccurringToggle.isOn,
                    paid:           true)
                
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        let request = response.notification.request
        
        if identifier == "paid" {
            
            if let changingReallySimpleNote = self.changingReallySimpleNote {
                // change the note through note storage
                NoteStorage.storage.changeNote(
                    
                    noteToBeChanged: SimpleNote(
                        noteId:        changingReallySimpleNote.noteId,
                        noteTitle:     changingReallySimpleNote.noteTitle,
                        notes:         changingReallySimpleNote.notes,
                        amount:        changingReallySimpleNote.amount,
                        actualDate:    changingReallySimpleNote.actualDate,
                        recurring:     changingReallySimpleNote.recurring,
                        paid:          true)
                )
                
//                addNotification()
                
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                
                let markAsPaidAction = UNNotificationAction(
                    identifier: "paid",
                    title: "Paid",
                    options: [])
                
                let ignoreAction = UNNotificationAction(
                identifier: "ignore",
                title: "Ignore",
                options: [])
                
                let alarmCategory = UNNotificationCategory(
                    identifier: "alarm",
                    actions: [markAsPaidAction, ignoreAction],
                    intentIdentifiers: [],
                    options: [])
                center.setNotificationCategories([alarmCategory])
                
                let dateInSettings = UserDefaults.standard.string(forKey: "timeConst")
                let time = dateInSettings!.toDate(dateFormat: "HH:mm")
                let calendar = Calendar.current
                let heure = calendar.component(.hour, from: time)
                let minuite = calendar.component(.minute, from: time)
                
                content.title = noteTitleTextField.text!
                content.body = noteTextAmountView.text! + " Due Soon"
                content.categoryIdentifier = "alarm"
                content.userInfo = ["customData": "fizzbuzz"]
                content.sound = UNNotificationSound.default
                
                var dateComponents = DateComponents()
                dateComponents.hour = heure
                dateComponents.minute = minuite
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
                
            } else if identifier == "carryForward" {
                
                
                
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
        
           completionHandler()
        }
        
    }

    var detailsToFill: SimpleNote? {
        didSet {
            // Update the view.
        }
    }

}
