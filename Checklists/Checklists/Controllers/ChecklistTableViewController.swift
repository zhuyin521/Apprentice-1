//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

private enum CheckListViewControllerSegue: String {
    case AddItem, EditItem
}

class ChecklistTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    // MARK: - Properties
    var checklist: Checklist!
    // MARK: - Private properties
    private let cellIdentifier = "ChecklistItem"
    private let LabelTagID = 1000
    private let CheckmarkTagID = 1001
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, let segueID = CheckListViewControllerSegue(rawValue: id) {
            switch segueID {
            case .AddItem:
                let dest = segue.destination as! ItemDetailViewController
                dest.delegate = self
            case .EditItem:
                let dest = segue.destination as! ItemDetailViewController
                dest.delegate = self
                let cell = sender as! UITableViewCell
                if let index = tableView.indexPath(for: cell) {
                    let item = checklist[index.row]
                    dest.itemToEdit = item
                }
            }
        }
    }
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = checklist[indexPath.row]
        configureCell(cell, with: item)
        return cell
    }
    // When this method is present, table view will automatically enable swipe-to-delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Remove item from checklist
        checklist.removeItem(at: indexPath.row)
        // Remove item from table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist[indexPath.row]
            item.toggleChecked()
            configureCell(cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Item detail view controller delegate methods
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, addedItem item: ChecklistItem) {
        // Grab new items index
        let newIndex = checklist.count
        // Add item to checklist
        checklist.addItem(item)
        // Update table view
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        // ChecklistItem must conform to Equatable protocol to use index(of:)
        if let index = checklist.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Private methods
    private func configureCell(_ cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(LabelTagID) as! UILabel
        let checkmarkLabel = cell.viewWithTag(CheckmarkTagID) as! UILabel
        label.text = item.text
        checkmarkLabel.text = (item.checked) ? "✓" : "-"
    }
}
