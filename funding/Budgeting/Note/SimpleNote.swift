//
//  SimpleNote.swift
//  funding
//
//  Created by Daniel Nzioka on 10/21/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import CoreData

class SimpleNote {
    
    private(set) var noteId      : UUID
    private(set) var noteTitle   : String
    private(set) var amount      : String
    private(set) var notes       : String
    private(set) var actualDate  : Date
    private(set) var recurring   : Bool
    private(set) var paid        : Bool
    
    
    init(noteTitle: String, amount: String, notes: String, actualDate: Date, recurring: Bool, paid: Bool) {
        self.noteId =     UUID()
        self.noteTitle =  noteTitle
        self.amount =     amount
        self.notes =      notes
        self.actualDate = actualDate
        self.recurring = recurring
        self.paid = paid
    }
    
    init(noteId: UUID, noteTitle: String, notes: String, amount: String, actualDate: Date, recurring: Bool, paid: Bool) {
      self.noteId =       noteId
      self.noteTitle =    noteTitle
      self.amount =       amount
      self.notes =        notes
      self.actualDate = actualDate
      self.recurring = recurring
      self.paid = paid
    }
    
}
