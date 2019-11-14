//
//  MoveNotesViewController.swift
//  Palvi_c0762152_note_p2
//
//  Copyright © 2019 Palvi. All rights reserved.
//

import UIKit

protocol MoveNotesViewControllerDelegate: class {
    func didMovedNotes(destinationFolder: Folder)
}

class MoveNotesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var arrayFolders = [Folder]()
    var arraySelectedNotes = [String]()
    
    weak var delegate: MoveNotesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Move to folder..."
    }
    
    @IBAction func methodToDismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MoveNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = arrayFolders[indexPath.row].name
        
        return cell
    }
}

extension MoveNotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "Move to \(self.arrayFolders[indexPath.row].name)", message: "Are you sure?", preferredStyle: .alert)
        
        let moveAction = UIAlertAction(title: "Move", style: .default, handler: { alert -> Void in
            self.delegate?.didMovedNotes(destinationFolder: self.arrayFolders[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)
        alertController.addAction(moveAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
