//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Forrest Ching on 7/20/16.
//  Copyright © 2016 Urban Forrest. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        //Caveman Debug
            print("'Record Brah!' pressed")
        
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
        //Caveman Debug
            print("'Stop Recording' pressed")
        
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
        stopRecordingButton.enabled = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //Caveman Debug
            print("AVAudioRecorder finished saving recording")
        
        //If success, segue.  Else print error
            if(flag){
                self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
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

