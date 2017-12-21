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

    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let label = cell.viewWithTag(labelTagID) as! UILabel
        let remainder = indexPath.row % 5
        switch remainder {
        case 0:
            label.text = "Walk the dog"
        case 1:
            label.text = "Brush my teeth"
        case 2:
            label.text = "Learn iOS development"
        case 3:
            label.text = "Soccer practice"
        default:
            label.text = "Eat ice cream"
        }
        return cell
    }

    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
