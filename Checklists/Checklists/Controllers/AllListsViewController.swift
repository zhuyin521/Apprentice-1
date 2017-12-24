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

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    // MARK: - Properties
    var dataModel: DataModel!
    // MARK: - Private properties
    private let CellID = "Cell"
    // MARK: - View controller methods
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
                let indexPath = sender as! IndexPath
                let list = dataModel[indexPath.row]
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
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = dataModel[indexPath.row]
        performSegue(withIdentifier: AllListsViewControllerSegue.ShowChecklist.rawValue, sender: list)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.removeList(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: AllListsViewControllerSegue.EditChecklist.rawValue, sender: indexPath)
    }
    // MARK: - List detail delegate
    func listItemDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishAdding list: Checklist) {
        let index = dataModel.count
        dataModel.addList(list)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    func listItemDetailViewController(_ controller: ListDetailViewController, didFinishEditing list: Checklist) {
        if let index = dataModel.index(of: list) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = list.name
            }
        }
        navigationController?.popViewController(animated: true)
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
