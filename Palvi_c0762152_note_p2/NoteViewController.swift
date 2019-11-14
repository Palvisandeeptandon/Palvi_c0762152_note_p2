//
//  NoteViewController.swift
//  Palvi_c0762152_note_p2
//
//  Copyright © 2019 Palvi. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: class {
    func addedNotes(note: String)
    func editedNotes(note: String, index: Int)
}

class NoteViewController: UIViewController {
    
    var note = String()
    @IBOutlet private weak var textView: UITextView!
    
    var isToEdit = false
    var index = Int()
    
    weak var delegate: NoteViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.text = note
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        if isToEdit {
            self.delegate?.editedNotes(note: text, index: index)
        } else {
            self.delegate?.addedNotes(note: text)
        }
    }

}
