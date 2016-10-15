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
  
    var startedAt = Date()
    var subtitles = Subtitle()
    var timer = Timer()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
    @IBAction func playSubtitle(_ sender: AnyObject) {
        subtitles = Subtitle()
        
      // stop previous timer (if any)
      // lookup stanza to play
      // start timer
        //  subtitleDisplay.text = subtitleInteger.text
        let i = Int(subtitleInteger.text!) ?? 0
        
        startShowing(index: i)
    }
    
    func startShowing(index: Int) {
        let stanza = subtitles.Stanzas[index]
        startedAt = Date(timeIntervalSinceNow: -stanza.on_at)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSubtitle), userInfo: nil, repeats: true)
    }
    
    func stopShowing() {
        timer.invalidate()
        subtitleDisplay.text = "Subtitle player stopped"
    }
  
    func updateSubtitle() {
        let elapsed = Date().timeIntervalSince(startedAt)
        for stanza in self.subtitles.Stanzas {
            if stanza.on_at < elapsed && elapsed <= stanza.off_at {
                subtitleDisplay.text = stanza.lines[0]
                return
            }
        }
        subtitleDisplay.text = ""
//        // let elapsed = startedAt.timeIntervalSinceNow  
//        // subtitleDisplay.text = elapsed.description
//        subtitleDisplay.text = elapsed.description
    }

}

