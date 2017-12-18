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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let difference: Int = abs(currentValue - targetValue)
        // The highest amount of points you can get is 100
        let points = 100 - difference
        score += points
        let message = "You got \(points) points"
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
        round += 1
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }

    // updateLabels() is called at the end of startNewRound()
    private func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
}

