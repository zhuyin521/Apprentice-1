//
//  ViewController.swift
//  BullsEye
//
//  Created by Joshua Tate on 2017-12-17.
//  Copyright © 2017 Magk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let alertVC = UIAlertController(title: "Hello World!",
                                        message: "This is my first app!",
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome",
                                   style: .default,
                                   handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}

