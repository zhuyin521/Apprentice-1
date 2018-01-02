//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Joshua Tate on 2018-01-01.
//  Copyright © 2018 Magk. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    // MARK: - Actions
    @IBAction func getMyLocation(_ sender: Any) {
    }
}

