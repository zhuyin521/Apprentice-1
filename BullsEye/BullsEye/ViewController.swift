//
//  ViewController.swift
//  BullsEye
//
//  Created by Joshua Tate on 2017-12-17.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    var currentValue: Int = 0
    var targetValue: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)" +
                      "\nThe target value is: \(targetValue)"
        let alertVC = UIAlertController(title: "Hello World!",
                                        message: message,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
        startNewRound()
    }

    @IBAction func sliderMoved(_ sender: UISlider) {
        // lroundf rounds decimals to the nearest whole number
        currentValue = lroundf(sender.value)
    }

    private func startNewRound() {
        // arc4random_uniform(100) returns a UInt32 from 0..99
        // target value will get a random number from 1..100
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }

    // updateLabels() is called at the end of startNewRound()
    private func updateLabels() {
        targetLabel.text = String(targetValue)
    }
}

