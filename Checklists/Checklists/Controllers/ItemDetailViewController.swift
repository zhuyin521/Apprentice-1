//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, addedItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    // MARK: - Instance properties
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    // MARK: - IBOutlet properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if itemToEdit is non-nil, if so, create edit screen
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneButton.isEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make keyboard available as soon as view controller
        //  becomes active
        textField.becomeFirstResponder()
    }
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Return nil from this method when you do not want the cell
        //  to be selectable.
        // WARNING: Change selection type in storyboard to None
        // Sometimes the cell will still be selected for a brief second
        return nil
    }
    // MARK: - Text field delegate methods
    // textField(_:shouldChangeCharactersIn:replacementString:) tells you which part of the text
    //  (the range) should be replaced, and the text it should be replaced with (the string)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Calculate what the new text will be:
        // 1. Get the old/exisiting text
        let oldText = textField.text!
        // 2. Get the range in the existing text
        let stringRange = Range(range, in: oldText)!
        // 3. Create new text by replacing characters in range with the new string
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // Set done button to enabled only if the new text is not empty
        doneButton.isEnabled = !newText.isEmpty
        // Return true to indicate that text field should proceed with text replacement
        return true
    }
    // MARK: - Action methods
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            delegate?.itemDetailViewController(self, addedItem: item)
        }
    }
}
