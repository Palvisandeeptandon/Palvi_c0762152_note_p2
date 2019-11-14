//
//  FoldersViewController.swift
//  Palvi_c0762152_note_p2
//
//  Copyright © 2019 Palvi. All rights reserved.
//

import UIKit

struct Folder {
    var name = String()
    var arrayNotes = [String]()
}

class FoldersTableViewCell: UITableViewCell {
    @IBOutlet weak var numberOfNotesLabel: UILabel!
}

class FoldersViewController: UIViewController {
    
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    var arrayFolders = [Folder]()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Folders"
    }
    
    @IBAction func createNewFolder(_ sender: Any) {
        let alertController = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        let saveAction = UIAlertAction(title: "Add Item", style: .default, handler: { alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            guard let folderName = nameTextField.text else {
                return
            }
            
            if self.arrayFolders.contains(where: { $0.name ==  folderName }) {
                self.showAlertForDuplicateFolder(folderName: folderName)
                return
            }
            
            let folder = Folder(name: folderName, arrayNotes: [])
            
            self.arrayFolders.append(folder)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertForDuplicateFolder(folderName: String) {
        let alertController = UIAlertController(title: "Name Taken", message: "Please choose a different name.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startEditing(_ sender: Any) {
        
        editButton.title = editButton.title == "Edit" ? "Done" : "Edit"
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}

extension FoldersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! FoldersTableViewCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(named: "folder")
        cell.textLabel?.text = arrayFolders[indexPath.row].name
        
        cell.numberOfNotesLabel.text = String(describing: arrayFolders[indexPath.row].arrayNotes.count)
        
        return cell
    }
}

extension FoldersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayFolders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.editButton.title = "Done"
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.editButton.title = "Edit"
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let folderToMove = arrayFolders[sourceIndexPath.row]
        
        arrayFolders.insert(folderToMove, at: destinationIndexPath.row)
        arrayFolders.remove(at: sourceIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesViewController = storyBoard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        notesViewController.folder = arrayFolders[indexPath.row]
        notesViewController.arrayFolders = arrayFolders
        notesViewController.delegate = self
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }
}

extension FoldersViewController: NotesViewControllerDelegate {
    func didMovedNotes(arrayfolder: [Folder]) {
        self.arrayFolders = arrayfolder
        self.tableView.reloadData()
    }
    
    func didUpdatedNotes(folder: Folder) {
        if let index = arrayFolders.firstIndex(where: { $0.name == folder.name }) {
            arrayFolders[index] = folder
            self.tableView.reloadData()
        }
    }
}

