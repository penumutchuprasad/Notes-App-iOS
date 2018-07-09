//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    
    var notes = [Note]() {
        didSet {
            //When you want to update a table view by adding, modifying or deleting a cell, you need to explicitly tell the table view to reload it's data source using property observers,the didSet observes the notes property. If the property changes the code within the didSet block is executed
            tableView.reloadData()
        }
    }
        
        override func viewDidLoad(){
            super.viewDidLoad()
            //retrieve the user's previously existing notes:
            notes = CoreDataHelper.retrieveNotes()
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Dynamically return the number of notes in the notes array.
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        //Retrieve the correct note based on the index path row and set the note cell's labels with the corresponding data
        let note = notes[indexPath.row]
        cell.noteTitleLabel.text = note.title
        
        //We use the method convertToString() that was included in our project? to convert our modification time from type Date to String.
        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown" // we simply use optional chaining to address our modificationTime being changed to type Date?. In addition, we use the nil-coalescing operator to provide a default value if modificationTime is nil
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayNote":
            // 1
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // 2
            let note = notes[indexPath.row]
            // 3
            let destination = segue.destination as! DisplayNoteViewController
            // 4
            destination.note = note
            
        case "addNote":
            print("create note bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    //override the table view data source method tableView(_:commit:forRowAt:) to implement the table view's built-in slide-to-delete functionality. Within the tableView(_:commit:forRowAt:) method, we retrieve the note to be deleted corresponding to the selected index path. Then we use our Core Data helper to delete the selected note. Last we update our notes array to reflect the changes in our NSManagedObjectContext.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            let noteToDelete=notes[indexPath.row]
            CoreDataHelper.delete(note: noteToDelete)
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
        //each time the user taps the save or cancel bar button item in DisplayNoteViewController, we update our notes array in ListNotesTableViewController. Our didSet property observer will take care of reloading our table view. In combination, we can be sure our table view data is always synced with our NSManagedObjectContext.
        
        notes = CoreDataHelper.retrieveNotes()
    }
}
