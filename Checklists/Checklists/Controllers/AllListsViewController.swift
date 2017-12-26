//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-23.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

private enum AllListsViewControllerSegue: String {
    case ShowChecklist, AddChecklist, EditChecklist
}

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    var dataModel: DataModel!
    // MARK: - Private properties
    private let CellID = "Cell"
    // MARK: - View controller methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Will call cellForRow on table view delegate
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        // Check if ChecklistIndex is in valid range
        let index = dataModel.indexOfSelectedChecklist
        if (0..<dataModel.count).contains(index) {
            // Go to checklist that user was last viewing, before app
            //  was terminated
            let list = dataModel[index]
            performSegue(withIdentifier: AllListsViewControllerSegue.ShowChecklist.rawValue,
                         sender: list)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, let segueID = AllListsViewControllerSegue(rawValue: id) {
            switch segueID {
            case .ShowChecklist:
                let destination = segue.destination as! ChecklistTableViewController
                let list = sender as! Checklist
                destination.checklist = list
            case .AddChecklist:
                let destination = segue.destination as! ListDetailViewController
                destination.delegate = self
            case .EditChecklist:
                let destination = segue.destination as! ListDetailViewController
                destination.delegate = self
                let list = sender as! Checklist
                destination.checklist = list
            }
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let list = dataModel[indexPath.row]
        cell.textLabel?.text = list.name
        // Calculating and storing the count once is more optimal than doing it twice
        let count = list.uncheckedItemsCount
        if list.isEmpty {
            cell.detailTextLabel?.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel?.text = "All Done!"
        } else {
            cell.detailTextLabel?.text = "\(count) remaining"
        }
        let icon = Icon(rawValue: list.iconName)!
        cell.imageView?.image = icon.image()
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        dataModel.indexOfSelectedChecklist = index
        let list = dataModel[index]
        performSegue(withIdentifier: AllListsViewControllerSegue.ShowChecklist.rawValue, sender: list)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.removeList(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let list = dataModel[indexPath.row]
        performSegue(withIdentifier: AllListsViewControllerSegue.EditChecklist.rawValue, sender: list)
    }
    // MARK: - List detail delegate
    func listItemDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: Checklist) {
        dataModel.addList(list)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation controller delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // If viewController is self, back button was pressed
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    // MARK: - Private methods
    private func makeCell(for tableView: UITableView) -> UITableViewCell {
        // Here you use dequeueReusableCell(withIdentifier:) instead of dequeueReusableCell(withIdentifier:for:)
        //  because the second one only works if there is a prototype cell. The app would crash
        //  if you used the "for" version
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellID) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: CellID)
        }
    }
}
