//
//  ViewController.swift
//  HealthHackJazzHands
//
//  Created by Julian Scharf on 15/10/2016.
//  Copyright © 2016 Julian Scharf. All rights reserved.
//

import UIKit

var lmPath: String!
var dicPath: String!
var words: Array<String> = []
var currentWord: String!

var kLevelUpdatesPerSecond = 18


class ViewController: UIViewController , OEEventsObserverDelegate {
    
    @IBOutlet weak var subtitleInteger: UITextField!
    @IBOutlet weak var subtitleDisplay: UILabel!
  
    var startedAt = Date()
    var subtitles = Subtitle()
    var timer = Timer()
  
    override func viewDidLoad() {
        super.viewDidLoad()
                loadOpenEars()
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
    
    
    var openEarsEventsObserver = OEEventsObserver()
    var startupFailedDueToLackOfPermissions = Bool()
    
    var buttonFlashing = false
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var heardTextView: UITextView!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var timeHeardTextView: UITextView!
    

    
    @IBAction func record(sender: AnyObject) {
        
        if !buttonFlashing {
            startFlashingbutton()
            startListening()
        } else {
            stopFlashingbutton()
            stopListening()
        }
    }
    
    func startFlashingbutton() {
        
        buttonFlashing = true
        recordButton.backgroundColor = UIColor.red
        
    }
    
    func stopFlashingbutton() {
        
        buttonFlashing = false
        recordButton.backgroundColor = UIColor.green
        
    }
    //OpenEars methods begin
    
    func loadOpenEars() {
        
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        let lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        
        addWords()
        let name = "LanguageModelFileStarSaver"
        lmGenerator.generateLanguageModel(from: words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
    }
    
    
    func pocketsphinxDidStartListening() {
        print("Pocketsphinx is now listening.")
        statusTextView.text = "Pocketsphinx is now listening."
    }
    
    func pocketsphinxDidDetectSpeech() {
        print("Pocketsphinx has detected speech.")
        statusTextView.text = "Pocketsphinx has detected speech."
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        print("Pocketsphinx has detected a period of silence, concluding an utterance.")
        statusTextView.text = "Pocketsphinx has detected a period of silence, concluding an utterance."
    }
    
    func pocketsphinxDidStopListening() {
        print("Pocketsphinx has stopped listening.")
        statusTextView.text = "Pocketsphinx has stopped listening."
    }
    
    func pocketsphinxDidSuspendRecognition() {
        print("Pocketsphinx has suspended recognition.")
        statusTextView.text = "Pocketsphinx has suspended recognition."
    }
    
    func pocketsphinxDidResumeRecognition() {
        print("Pocketsphinx has resumed recognition.")
        statusTextView.text = "Pocketsphinx has resumed recognition."
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
        print("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String) {
        print("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
        statusTextView.text = "Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)"
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        print("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
        statusTextView.text = "Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)"
    }
    
    func testRecognitionCompleted() {
        print("A test file that was submitted for recognition is now complete.")
        statusTextView.text = "A test file that was submitted for recognition is now complete."
    }
    
    func startListening() {
        OEPocketsphinxController.sharedInstance().vadThreshold  = (512)
        OEPocketsphinxController.sharedInstance().secondsOfSilenceToDetect = (0.1)
        
        
        do {
            try OEPocketsphinxController.sharedInstance().setActive(true)
        } catch {
            print("startlistening failed")
        }
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func stopListening() {
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    
    func addWords() {
        //add any thing here that you want to be recognized. Must be in capital letters
        words.append("I DONT GIVE SHITTY JOBS")
        
    }
    
    func getNewWord() {
        let randomWord = Int(arc4random_uniform(UInt32(words.count)))
        currentWord = words[randomWord]
    }
    
    func pocketsphinxFailedNoMicPermissions() {
        
        NSLog("Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.")
        self.startupFailedDueToLackOfPermissions = true
        if OEPocketsphinxController.sharedInstance().isListening {
            let error = OEPocketsphinxController.sharedInstance().stopListening() // Stop listening if we are listening.
            if(error != nil) {
                //                NSLog("Error while stopping listening in micPermissionCheckCompleted: %@", error);
            }
        }
    }
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        
        heardTextView.text = "Heard: \(hypothesis)"
        if hypothesis.contains("SHITTY JOBS") {
            let timestamp = NSDate().timeIntervalSince1970
            timeHeardTextView.text = String(timestamp)
            startShowing(index: 1)
        }
        
        
    }


}

