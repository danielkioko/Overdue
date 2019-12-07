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
    private(set) var noteType    : String
    private(set) var actualDate  : Date
    
    
    init(noteTitle: String, amount: String, notes: String, noteType: String, actualDate: Date) {
        self.noteId =     UUID()
        self.noteTitle =  noteTitle
        self.amount =     amount
        self.notes =      notes
        self.noteType =   noteType
        self.actualDate = actualDate
    }
    
    init(noteId: UUID, noteTitle: String, notes: String, amount: String, noteType: String, actualDate: Date) {
      self.noteId =       noteId
      self.noteTitle =    noteTitle
      self.amount =       amount
      self.notes =        notes
      self.noteType =     noteType
      self.actualDate = actualDate
    }
    
}
