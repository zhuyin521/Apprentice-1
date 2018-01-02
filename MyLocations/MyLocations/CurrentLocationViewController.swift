//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Joshua Tate on 2018-01-01.
//  Copyright © 2018 Magk. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var updatingLocation = false
    private var lastLocationError: Error?
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    // MARK: - View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    // MARK: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
        // When locationUnknown, location manager is still attempting to find location
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        print("didUpdateLocations: \(lastLocation)")
        location = lastLocation
        lastLocationError = nil
        updateLabels()
    }
    // MARK: - Actions
    @IBAction func getMyLocation(_ sender: Any) {
        // Get permission
        // Remember to add key value pair in Info.plist
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        startLocationManager()
        updateLabels()
    }
    // MARK: - Methods
    private func showLocationServicesDeniedAlert() {
        let alertVC = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    private func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            tagButton.isHidden = true
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled."
                } else {
                    statusMessage = "Error Getting Location."
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled."
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' Button to Start."
            }
            messageLabel.text = statusMessage
        }
    }
    private func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // Begin receiving coordinates
            updatingLocation = true
        }
    }
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
}

