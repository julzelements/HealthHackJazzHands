//
//  ViewController.swift
//  HealthHackJazzHands
//
//  Created by Julian Scharf on 15/10/2016.
//  Copyright © 2016 Julian Scharf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var subtitleInteger: UITextField!
    @IBOutlet weak var subtitleDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
    @IBAction func playSubtitle(_ sender: AnyObject) {
        subtitleDisplay.text = subtitleInteger.text
    
    }

}

