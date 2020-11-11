//
//  NoteCoreDataHelper.swift
//  funding
//
//  Created by Daniel Nzioka on 10/21/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import Foundation
import CoreData

class NoteCoreDataHelper {
    
    private(set) static var count: Int = 0
    
    static func createNoteInCoreData(
        noteToBeCreated:          SimpleNote,
        intoManagedObjectContext: NSManagedObjectContext) {
        
        // Let’s create an entity and new note record
        let noteEntity = NSEntityDescription.entity(
            forEntityName: "Note",
            in:            intoManagedObjectContext)!
        
        let newNoteToBeCreated = NSManagedObject(
            entity:     noteEntity,
            insertInto: intoManagedObjectContext)

        newNoteToBeCreated.setValue(
            noteToBeCreated.noteId,
            forKey: "noteId")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTitle,
            forKey: "noteTitle")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.notes,
            forKey: "notes")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.amount,
            forKey: "amount")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.actualDate,
            forKey: "actualDate")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.recurring,
            forKey: "recurring")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.paid,
            forKey: "paid")
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func changeNoteInCoreData(
        noteToBeChanged:        SimpleNote,
        inManagedObjectContext: NSManagedObjectContext) {
        
        // read managed object
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteToBeChanged.noteId as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            // make the changes
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTitle,
                forKey: "noteTitle")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.amount,
                forKey: "amount")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.actualDate,
                forKey: "actualDate")
            
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.notes,
                forKey: "notes")
            
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.recurring,
                forKey: "recurring")
            
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.paid,
                forKey: "paid")

            // save
            try inManagedObjectContext.save()

        } catch let error as NSError {
            // TODO error handling
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [SimpleNote] {

        var returnedNotes = [SimpleNote]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                
                returnedNotes.append(SimpleNote.init(
                    noteId:     noteManagedObjectRead.value(forKey: "noteId") as! UUID,
                    noteTitle:  noteManagedObjectRead.value(forKey: "noteTitle") as! String,
                    notes:      noteManagedObjectRead.value(forKey: "notes") as! String,
                    amount:     noteManagedObjectRead.value(forKey: "amount") as! String,
                    actualDate: noteManagedObjectRead.value(forKey: "actualDate") as! Date,
                    recurring:  noteManagedObjectRead.value(forKey: "recurring") as! Bool,
                    paid:       noteManagedObjectRead.value(forKey: "paid") as! Bool))
                
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        // set note count
        self.count = returnedNotes.count
        
        return returnedNotes
    }
    
    static func readNoteFromCoreData(
        noteIdToBeRead:           UUID,
        fromManagedObjectContext: NSManagedObjectContext) -> SimpleNote? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            return SimpleNote.init(
                noteId:     noteManagedObjectToBeRead.value(forKey: "noteId") as! UUID,
                noteTitle:  noteManagedObjectToBeRead.value(forKey: "noteTitle") as! String,
                notes:      noteManagedObjectToBeRead.value(forKey: "notes") as! String,
                amount:     noteManagedObjectToBeRead.value(forKey: "amount") as! String,
                actualDate: noteManagedObjectToBeRead.value(forKey: "actualDate") as! Date,
                recurring:  noteManagedObjectToBeRead.value(forKey: "recurring") as! Bool,
                paid:       noteManagedObjectToBeRead.value(forKey: "paid") as! Bool)
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
        
    }

    static func deleteNoteFromCoreData(
        noteIdToBeDeleted:        UUID,
        fromManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdAsCVarArg: CVarArg = noteIdToBeDeleted as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            fromManagedObjectContext.delete(noteManagedObjectToBeDeleted)
            
            do {
                try fromManagedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            
        }
        
    }
    
}
