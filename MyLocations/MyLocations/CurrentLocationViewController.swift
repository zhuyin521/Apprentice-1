//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Joshua Tate on 2018-01-01.
//  Copyright © 2018 Magk. All rights reserved.
//

import UIKit
import CoreLocation

extension CLPlacemark {
    func toString() -> String {
        let line1 = [subThoroughfare, thoroughfare].reduce("") { (result, curr) in
            (curr == nil) ? result : result + " " + curr!
        }.trimmingCharacters(in: .whitespacesAndNewlines)
        let line2 = [locality, administrativeArea, postalCode].reduce("") { (result, curr) in
            (curr == nil) ? result : result + " " + curr!
        }.trimmingCharacters(in: .whitespacesAndNewlines)
        return line1 + "\n" + line2
    }
}

enum CurrentLocationSegue: String {
    case LocationDetail
}

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    // MARK: - Location properties
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var updatingLocation = false
    private var lastLocationError: Error?
    // MARK: - Geocoding properties
    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var performingReverseGeocoding = false
    private var lastGeocodingError: Error?
    private var timer: Timer?
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
        // If the time at which the given location object was too long ago,
        //  5 seconds in the case, then it is a cached result.
        if lastLocation.timestamp.timeIntervalSinceNow < -5 {
            // Ignore the cached locations if they are too old.
            return
        }
        // If the horizontal accuracy is less than zero, than the measurement
        //  is invalid, and you should ignore it.
        if lastLocation.horizontalAccuracy < 0 {
            return
        }
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = lastLocation.distance(from: location)
        }
        // NOTE: A larger accuracy value means it is LESS accurate
        if location == nil || location!.horizontalAccuracy > lastLocation.horizontalAccuracy {
            lastLocationError = nil
            location = lastLocation
            // If the new locations accuracy is less than or equal to the desired accuracy,
            //  then you can stop updating the location.
            if lastLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            // NOTE: Geocoding sends requests to Apple's servers, should limit calls to the geocoder
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { [weak self] (placemarks, error) in
                    self?.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self?.placemark = p.last!
                    } else {
                        self?.placemark = nil
                    }
                    self?.performingReverseGeocoding = false
                    self?.updateLabels()
                })
            }
        } else if distance < 1 {
            let timeInterval = lastLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
            }
        }
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
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }
    // MARK: - Methods
    @objc func didTimeOut() {
        print("*** Time Out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }
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
            if let placemark = placemark {
                addressLabel.text = placemark.toString()
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address found"
            }
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
        configureGetButton()
    }
    private func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // Begin receiving coordinates
            updatingLocation = true
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    private func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    private func configureGetButton() {
        if updatingLocation {
            locationButton.setTitle("Stop", for: .normal)
        } else {
            locationButton.setTitle("Get My Location", for: .normal)
        }
    }
}

