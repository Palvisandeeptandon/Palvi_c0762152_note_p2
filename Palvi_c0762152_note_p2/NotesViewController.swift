//
//  NotesViewController.swift
//  Palvi_c0762152_note_p2
//
//  Copyright © 2019 Palvi. All rights reserved.
//

import UIKit

protocol NotesViewControllerDelegate: class {
    func didUpdatedNotes(folder: Folder)
    func didMovedNotes(arrayfolder: [Folder])
}

class NotesViewController: UIViewController {

    var folder = Folder()
    var arrayFolders = [Folder]()
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var moveNotesButton: UIBarButtonItem!
    
    private var arraySelectedNotes = [String]()
    
    weak var delegate: NotesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Notes"
    }
    
    @IBAction func methodToEnableDeleteAndMoveButton(_ sender: Any) {
        self.deleteButton.isEnabled = !self.deleteButton.isEnabled
        self.moveNotesButton.isEnabled = !self.moveNotesButton.isEnabled
    }
    
    @IBAction func methodCreateNewNotes(_ sender: Any) {
        self.navigateToNoteViewController(note: "", isToEdit: false)
    }
    
    func navigateToNoteViewController(note: String, isToEdit: Bool, index: Int = 0 ) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyBoard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteViewController.delegate = self
        noteViewController.note = note
        noteViewController.index = index
        noteViewController.isToEdit = isToEdit
        self.navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    @IBAction func methodDeleteNotes(_ sender: Any) {
        guard arraySelectedNotes.count > 0 else {
            return
        }
        
        for selectedCell in arraySelectedNotes {
            let indexOfSelectedCell = self.folder.arrayNotes.firstIndex(of: selectedCell)
            self.folder.arrayNotes.remove(at: indexOfSelectedCell!)
            self.tableView.deleteRows(at: [IndexPath(row: indexOfSelectedCell!, section: 0)], with: .automatic)
        }
        self.arraySelectedNotes.removeAll()
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
    
    @IBAction func methodMoveNotesToFolder(_ sender: Any) {
        guard arraySelectedNotes.count > 0 else {
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let moveNotesViewController = storyBoard.instantiateViewController(withIdentifier: "MoveNotesViewController") as! MoveNotesViewController
        moveNotesViewController.arrayFolders = arrayFolders
        moveNotesViewController.arraySelectedNotes = arraySelectedNotes
        moveNotesViewController.delegate = self
        self.present(UINavigationController(rootViewController: moveNotesViewController) , animated: true, completion: nil)
    }
    
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.selectionStyle = .none
        
        if arraySelectedNotes.contains(folder.arrayNotes[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .detailButton
        }
        
        cell.textLabel?.text = folder.arrayNotes[indexPath.row]
        
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if arraySelectedNotes.contains(folder.arrayNotes[indexPath.row]) {
            let indexOfSelectedCell = arraySelectedNotes.firstIndex(of: folder.arrayNotes[indexPath.row])
            arraySelectedNotes.remove(at: indexOfSelectedCell!)
            cell!.accessoryType = .detailButton
        } else {
            arraySelectedNotes.append(folder.arrayNotes[indexPath.row])
            cell!.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.navigateToNoteViewController(note: self.folder.arrayNotes[indexPath.row], isToEdit: true, index: indexPath.row)
    }
}

extension NotesViewController: NoteViewControllerDelegate {
    func editedNotes(note: String, index: Int) {
        self.folder.arrayNotes[index] = note
        self.tableView.reloadData()
        if let index = arrayFolders.firstIndex(where: { $0.name == folder.name }) {
            arrayFolders[index] = folder
        }
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
    
    func addedNotes(note: String) {
        self.folder.arrayNotes.append(note)
        self.tableView.reloadData()
        if let index = arrayFolders.firstIndex(where: { $0.name == folder.name }) {
            arrayFolders[index] = folder
        }
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
}

extension NotesViewController: MoveNotesViewControllerDelegate {
    func didMovedNotes(destinationFolder: Folder) {
        
        if destinationFolder.name == self.folder.name {
            return
        }
        
        guard let sourceIndex = self.arrayFolders.firstIndex(where: { $0.name == self.folder.name }),
            let destinationIndex = self.arrayFolders.firstIndex(where: { $0.name == destinationFolder.name })  else {
            return
        }
        
        self.arrayFolders[destinationIndex].arrayNotes.append(contentsOf: self.arraySelectedNotes)
        
        for selectedCell in arraySelectedNotes {
            let indexOfSelectedCell = self.folder.arrayNotes.firstIndex(of: selectedCell)
            self.folder.arrayNotes.remove(at: indexOfSelectedCell!)
            self.tableView.deleteRows(at: [IndexPath(row: indexOfSelectedCell!, section: 0)], with: .automatic)
        }
        self.arraySelectedNotes.removeAll()
        self.arrayFolders[sourceIndex] = self.folder
        self.delegate?.didMovedNotes(arrayfolder: self.arrayFolders)
    }
}
