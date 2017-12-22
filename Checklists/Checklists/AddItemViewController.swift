//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Joshua Tate on 2017-12-21.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Return nil from this method when you do not want the cell
        //  to be selectable.
        // WARNING: Change selection type in storyboard to None
        // Sometimes the cell will still be selected for a brief second
        return nil
    }
    // MARK: - Action methods
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
