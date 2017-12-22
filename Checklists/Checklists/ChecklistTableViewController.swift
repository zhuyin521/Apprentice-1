//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController, AddItemViewControllerDelegate {
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
        if segue.identifier == AddItemViewController.SegueID {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.delegate = self
        }
    }
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = checklistItems[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
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
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Add item view controller delegate methods
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    func addItemViewController(_ controller: AddItemViewController, addedItem item: ChecklistItem) {
        // Grab new items index
        let newIndex = checklistItems.count
        // Add item to array
        checklistItems.append(item)
        // Update table view
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
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
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(LabelTagID) as! UILabel
        label.text = item.text
    }
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let checkmarkLabel = cell.viewWithTag(CheckmarkTagID) as! UILabel
        checkmarkLabel.text = (item.checked) ? checkmark : ""
    }
}
