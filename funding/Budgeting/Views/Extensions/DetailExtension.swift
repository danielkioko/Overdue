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
    
    func customize() {
        
        editBtn.layer.cornerRadius = 10
        editBtn.layer.shadowColor = UIColor.black.cgColor
        editBtn.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        editBtn.layer.shadowOpacity = 0.2
        editBtn.layer.shadowRadius = 4.0
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4.0
        
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
