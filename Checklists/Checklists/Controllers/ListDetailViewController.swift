//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listItemDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: Checklist)
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    // MARK: - Properties
    weak var delegate: ListDetailViewControllerDelegate?
    var checklist: Checklist?
    // MARK: - IBOutlet properties
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklist {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneButton.isEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    // MARK: - Text field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let range = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: range, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    // MARK: - Action methods
    @IBAction func cancel() {
        delegate?.listItemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklist {
            checklist.name = textField.text!
            delegate?.listItemDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listItemDetailViewController(self, didFinishAdding: checklist)
        }
    }
}
