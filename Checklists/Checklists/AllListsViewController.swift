//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

private enum AllListsViewControllerSegue: String {
    case ShowChecklist
}

class AllListsViewController: UITableViewController {
    // MARK: - Private properties
    private let CellID = "Cell"
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.textLabel?.text = "Label \(indexPath.row)"
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: AllListsViewControllerSegue.ShowChecklist.rawValue, sender: nil)
    }
    // MARK: - Private methods
    private func makeCell(for tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellID) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: CellID)
        }
    }
}
