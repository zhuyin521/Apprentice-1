//
//  LocationDetailViewController.swift
//  MyLocations
//
//  Created by Joshua Tate on 2018-01-03.
//  Copyright © 2018 Magk. All rights reserved.
//

import UIKit
import CoreLocation

extension Date {
    func toString() -> String {
        return ""
    }
}

class LocationDetailViewController: UITableViewController {
    // MARK: - Propeties
    var coordinates = CLLocationCoordinate2DMake(0, 0)
    var placemark: CLPlacemark?
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = ""
        categoryLabel.text = ""
        latitudeLabel.text = String(format: "%.8f", coordinates.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinates.longitude)
        if let placemark = placemark {
            addressLabel.text = placemark.toString()
        } else {
            addressLabel.text = "No Address Found"
        }
        dateLabel.text = format(date: Date())
    }
    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
