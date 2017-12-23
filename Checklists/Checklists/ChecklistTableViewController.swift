//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

enum CheckListViewControllerSeugue: String {
    case AddItem, EditItem
}

class ChecklistTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    // MARK: - Private properties
    private let cellIdentifier = "ChecklistItem"
    private let LabelTagID = 1000
    private let CheckmarkTagID = 1001
    private let checkmark = "✅"
    private var checklistItems = [ChecklistItem]()
    // MARK: - View controller methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addChecklistItems()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, let segueID = CheckListViewControllerSeugue(rawValue: id) {
            switch segueID {
            case .AddItem:
                let dest = segue.destination as! ItemDetailViewController
                dest.delegate = self
            case .EditItem:
                let dest = segue.destination as! ItemDetailViewController
                dest.delegate = self
                let cell = sender as! UITableViewCell
                if let index = tableView.indexPath(for: cell) {
                    let item = checklistItems[index.row]
                    dest.itemToEdit = item
                }
            }
        }
    }
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = checklistItems[indexPath.row]
        configureCell(cell, with: item)
        return cell
    }
    // When this method is present, table view will automatically enable swipe-to-delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Remove item from array
        checklistItems.remove(at: indexPath.row)
        // Remove item from table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklistItems[indexPath.row]
            item.toggleChecked()
            configureCell(cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Add item view controller delegate methods
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, addedItem item: ChecklistItem) {
        // Grab new items index
        let newIndex = checklistItems.count
        // Add item to array
        checklistItems.append(item)
        // Update table view
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        // ChecklistItem must conform to Equatable protocol to use index(of:)
        if let index = checklistItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Private methods
    private func addChecklistItems() {
        ["Walk the dog", "Brush my teeth", "Learn iOS Development",
         "Soccer practice", "Eat ice cream"].enumerated().forEach { (i, s) in
            let checked = (i == 1 || i == 2 || i == 4)
            checklistItems.append(ChecklistItem(text: s, checked: checked))
        }
    }
    private func configureCell(_ cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(LabelTagID) as! UILabel
        let checkmarkLabel = cell.viewWithTag(CheckmarkTagID) as! UILabel
        label.text = item.text
        checkmarkLabel.text = (item.checked) ? checkmark : ""
    }
}
