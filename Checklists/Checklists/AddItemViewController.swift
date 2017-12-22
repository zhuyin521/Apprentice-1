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
    // MARK: - Action methods
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
