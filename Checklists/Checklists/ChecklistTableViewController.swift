//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController {
    // MARK: - Private properties
    private let cellIdentifier = "ChecklistItem"
    private let labelTagID = 1000
    private var checklistItems = [ChecklistItem]()

    // MARK: - View controller methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addChecklistItems()
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

    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklistItems[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Private methods
    private func addChecklistItems() {
        (1...100).forEach { i in
            checklistItems.append(ChecklistItem(text: "Item \(i)", checked: false))
        }
    }
    private func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(labelTagID) as! UILabel
        label.text = item.text
    }
    private func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.accessoryType = (item.checked) ? .checkmark : .none
    }
}
