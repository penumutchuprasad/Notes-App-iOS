//
//  DisplayNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController {
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let note = note {
            // 2
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            // 3
            titleTextField.text = ""
            contentTextView.text = ""
        }
    }
    
    //used to tell us if an unwind segue from one of our bar button items is being triggered
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where note != nil:
            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            note?.modificationTime = Date()
            
            CoreDataHelper.saveNote()
        
        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.modificationTime = Date()
            
            CoreDataHelper.saveNote()   //what are these two casses?????
        case "cancel":
            print("cancel bar button item tapped")
        default:
            print("unexpected segue identifier")
        }
    }
}

//update our functionality in DisplayNoteViewController for creating new notes or modifying existing ones.
