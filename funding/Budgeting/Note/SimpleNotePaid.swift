//
//  SimpleNotePaid.swift
//  funding
//
//  Created by Daniel Nzioka on 1/8/20.
//  Copyright © 2020 Daniel Nzioka. All rights reserved.
//

import Foundation
import CoreData

class SimpleNotePaid {
    
    private(set) var noteId : UUID
    private(set) var paid : Bool
    
    init(paid: Bool) {
        self.noteId = UUID()
        self.paid = paid
    }
    
    init(noteId: UUID, paid: Bool) {
      self.noteId = noteId
      self.paid = paid
    }
    
}
