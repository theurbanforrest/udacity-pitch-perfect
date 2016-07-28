//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Forrest Ching on 7/20/16.
//  Copyright © 2016 Urban Forrest. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    /******** VARIABLES ********/
    //All the buttons
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UIButton!
    
    //UI Stack Views
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    
    //Audio
    var audioRecorder:AVAudioRecorder!
    

    /******** OVERRIDE FUNCS **********/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        setStackViewLayout()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Audio
        stopRecordingButton.enabled = false

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Audio
        if(segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            
            //UI
            self.setStackViewLayout()
            
            }, completion: nil)
    }
    
    /******** HELPER FUNCS ********/
    
    /*** UI ***/
    
    func setStackViewLayout() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        if orientation.isPortrait{
            self.outerStackView.axis = .Vertical
            self.setInnerStackViewsAxis(.Horizontal)
        } else {
            self.outerStackView.axis = .Horizontal
            self.setInnerStackViewsAxis(.Vertical)
        }
    }

    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView1.axis = axisStyle
        self.innerStackView2.axis = axisStyle
        self.innerStackView3.axis = axisStyle
    }
    
    /*** AUDIO ***/
    
    @IBAction func recordAudio(sender: AnyObject) {
        //Change UI
            recordingLabel.setTitle("Recording In Progress - Tap Stop to Stop", forState: UIControlState.Normal)
            stopRecordingButton.enabled = true
            recordButton.enabled = false

        //Record the sound
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath,recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
        
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        
        //Change UI
            recordingLabel.setTitle("Tap Mic to Record", forState: UIControlState.Normal)
            stopRecordingButton.enabled = false
            recordButton.enabled = true
        
        //Stop the recording
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //If success, segue.  Else print error
            if(flag){
                performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
            }
            else {
                print("Saving of recording failed")
            }
    }

}

