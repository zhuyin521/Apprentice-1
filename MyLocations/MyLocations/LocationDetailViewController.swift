//
//  LocationDetailViewController.swift
//  MyLocations
//
//  Created by Joshua Tate on 2018-01-03.
//  Copyright © 2018 Magk. All rights reserved.
//

import UIKit

class LocationDetailViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
