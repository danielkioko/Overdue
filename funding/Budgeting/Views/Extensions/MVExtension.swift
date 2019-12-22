//
//  MVExtension.swift
//  funding
//
//  Created by Daniel Nzioka on 11/7/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import UIKit

extension MasterViewController {
    
    func calculateRemainder(budgetedAmount: Int) -> Int {
        
        var totalCount: Int = 0
        var i = 0
        
        while (i < NoteStorage.storage.count()) {
            
            let object = NoteStorage.storage.readNote(at: i)
            totalCount += Int(object!.amount)!
            
            i += 1
            
        }
        
        return budgetedAmount - totalCount
    }
    
    func customize() {
    }
    
    func calculateTotalForMonth() {
        
        var amounts: [Int] = []
        var total: Int = 0
        var j = 0
        var k = 0
        
        while (k < NoteStorage.storage.count()) {
            
            let object = NoteStorage.storage.readNote(at: k)
            let monthEarlier = getCurrentMonthItems(date: Date())
            
            if (object!.actualDate <= Date() && object!.actualDate >= monthEarlier) {
                
                if let object = NoteStorage.storage.readNote(at: k) {
                    amounts.append(Int(object.amount) ?? 0)
                }
            }
                
            k += 1
        }
            
        while (j <= NoteStorage.storage.count()) {
            total = amounts.reduce(0, +)
            j += 1
        }
                
    }
    
    func getCurrentMonthItems(date: Date) -> Date {
        
        var pastMonth = Date()
        pastMonth.changeDays(by: -31)
        
        return pastMonth
        
    }
    
}

extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
