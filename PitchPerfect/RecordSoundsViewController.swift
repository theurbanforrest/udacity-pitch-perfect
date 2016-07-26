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
    
    var audioRecorder:AVAudioRecorder!
    
    /*
     STILL NEED TO FIX THIS!!
    */
    /* BEGIN udacity forums ui fix */
    
    // override this function to make sure when rotated to landscape, the buttons are not squeezed
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            if orientation.isPortrait{
                self.outerStackView.axis = .Vertical
            } else {
                self.outerStackView.axis = .Horizontal
            }
            }, completion: nil)
    }
    /* END udacity forums ui fix */
    

    @IBAction func recordAudio(sender: AnyObject) {
        //Change UI
            recordingLabel.setTitle("Recording In Progress", forState: UIControlState.Normal)
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
            recordingLabel.setTitle("Tap To Record", forState: UIControlState.Normal)
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
        //Caveman Debug
            print("AVAudioRecorder finished saving recording")
        
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

