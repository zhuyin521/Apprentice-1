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
    private var lists = [Checklist]()
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ["Birthdays", "Groceries", "Cool Apps", "To Do"].forEach {
            lists.append(Checklist(name: $0))
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: AllListsViewControllerSegue.ShowChecklist.rawValue, sender: nil)
    }
    // MARK: - Private methods
    private func makeCell(for tableView: UITableView) -> UITableViewCell {
        // Here you use dequeueReusableCell(withIdentifier:) instead of dequeueReusableCell(withIdentifier:for:)
        //  because the second one only works if there is a prototype cell. The app would crash
        //  if you used the "for" version
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellID) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: CellID)
        }
    }
}
