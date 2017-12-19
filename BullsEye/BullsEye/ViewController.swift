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
        startOver()
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
        let title: String
        if (difference == 0) {
            title = "Perfect!"
            score += 100
        } else if (difference == 1) {
            title = "SO CLOSE"
            score += 50
        } else if (difference < 5) {
            title = "You almost had it!"
        } else if (difference < 10) {
            title = "Pretty good!"
        } else {
            title = "Not even close.."
        }
        let message = "You got \(points) points"
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: {
                                    [weak self] _ in
                                    self?.startNewRound()
        })
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
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

    @IBAction func startOver() {
        score = 0
        round = 0
        startNewRound()
    }

    // updateLabels() is called at the end of startNewRound()
    private func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
}

