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

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    // MARK: - Properties
    weak var delegate: ListDetailViewControllerDelegate?
    var checklist: Checklist?
    // MARK: - Private properties
    private var icon: Icon = .Folder
    private let iconPickerSegueID = "PickIcon"
    // MARK: - IBOutlet properties
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklist {
            title = "Edit Checklist"
            textField.text = checklist.name
            icon = Icon(rawValue: checklist.iconName)!
            doneButton.isEnabled = true
        }
        iconImageView.image = icon.image()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == iconPickerSegueID {
            let iconPickerVC = segue.destination as! IconPickerViewController
            iconPickerVC.delegate = self
        }
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Allow selection for Icon picker cell, while making sure first cell is not selectable
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    // MARK: - Text field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let range = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: range, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    // MARK: - Icon picker delegate
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishPickingIcon icon: Icon) {
        self.icon = icon
        iconImageView.image = icon.image()
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Action methods
    @IBAction func cancel() {
        delegate?.listItemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if let checklist = checklist {
            checklist.name = textField.text!
            checklist.iconName = icon.rawValue
            delegate?.listItemDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: icon.rawValue)
            delegate?.listItemDetailViewController(self, didFinishAdding: checklist)
        }
    }
}
