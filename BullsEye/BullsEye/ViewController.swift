//
//  ViewController.swift
//  BullsEye
//
//  Created by Joshua Tate on 2017-12-17.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)"
        let alertVC = UIAlertController(title: "Hello World!",
                                        message: message,
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func sliderMoved(_ sender: UISlider) {
        // lroundf rounds decimals to the nearest whole number
        currentValue = lroundf(sender.value)
    }
}

