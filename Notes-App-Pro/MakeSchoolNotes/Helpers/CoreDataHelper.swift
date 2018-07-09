//
//  CoreDataHelper.swift
//  MakeSchoolNotes
//
//  Created by Ethan D'Mello on 2018-07-07.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//In the code below, we create a computed class variable that gets a reference to our app delegate's managed object context. We can use our reference to our NSManagedObjectContext to create, edit and delete NSManagedObject objects.
struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            fatalError()
        }
            let persistentContainer = appDelegate.persistentContainer
            let context = persistentContainer.viewContext
            
        return context
    }()
    
    //static method that creates a new note instance
    static func newNote() -> Note{
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        return note
    }
    
    static func saveNote(){
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(note: Note){ // is this saving something in a variable
    context.delete(note)
    saveNote()
    }
    
    static func retrieveNotes() -> [Note]{
        do{
            //create a NSFetchRequest to retrieve all Person objects
            let fetchRequest = NSFetchRequest<Note>(entityName:"Note")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
        return []
        }
    }
}

