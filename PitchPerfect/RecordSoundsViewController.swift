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

    //All the buttons
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UIButton!
    
    //UI Stack Views
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView: UIStackView!
    
    //UI Stack Views
    //@IBOutlet weak var outerStackView: UIStackView!
    //@IBOutlet weak var innerStackView1: UIStackView!
    //@IBOutlet weak var innerStackView2: UIStackView!
    
    var audioRecorder:AVAudioRecorder!
    
    /* BEGIN udacity forums ui fix */
    
    // helper function: all the innerStackView should share the same style, configure them together
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView.axis = axisStyle
    }
    
    // override this function to make sure when rotated to landscape, the buttons are not squeezed
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            if orientation.isPortrait{
                self.outerStackView.axis = .Vertical
                self.setInnerStackViewsAxis(.Horizontal)
            } else {
                self.outerStackView.axis = .Horizontal
                self.setInnerStackViewsAxis(.Vertical)
            }
            }, completion: nil)
    }
    /* END udacity forums ui fix */
 
    

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.enabled = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

