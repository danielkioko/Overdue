//
//  DetailExtension.swift
//  funding
//
//  Created by Daniel Nzioka on 10/23/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController {
    
    func countItemsInCategory() {
        
        if let detail = detailItem {
        
            var p = 0
            var pCount = 0
            while (p < NoteStorage.storage.count()) {
                
                let item = NoteStorage.storage.readNote(at: p)
                if (item?.noteType == detail.noteType) {
                    pCount += 1
                }
                
                p += 1
                
            }
            
            if (p == 1) {
                categoryCount.text = "There is " + String(pCount) + " other item in this category"
            } else if (p > 1) {
                categoryCount.text = "There is " + String(pCount) + " other items in this category"
            } else if (p == 0) {
                categoryCount.text = "No other items in this category"
            }
                        
        }

        
    }

    func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    func daysToDueDate() {
        
        var result: Int = 0
        let currentDate = Date()
            
        if detailItem != nil {
            let dueDate = detailItem?.actualDate
           result = calculateDaysBetweenTwoDates(start: currentDate, end: dueDate!)
            
            if (result < 0) {
                labelToDueDate.text = "Past Due!"
                labelToDueDate.textColor = UIColor.red
            } else if (result == 0) {
                labelToDueDate.text = "Due Today!"
                labelToDueDate.textColor = UIColor.orange
            } else if (result == 1) {
                labelToDueDate.text = "Due in a day!"
                labelToDueDate.textColor = UIColor.orange
            } else {
                labelToDueDate.text = String(result) + " Days to Due Date"
                labelToDueDate.textColor = UIColor.blue
            }
        
        }
        
    }
    
    func customizeButtons() {
        ebLayer.layer.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.2078431373, blue: 0.3490196078, alpha: 1)
        ebLayer.layer.cornerRadius = 0
    }
    
    @objc
    func doneBtnAction() {
        self.view.endEditing(true)
    }
    
}

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
