//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Forrest Ching on 7/22/16.
//  Copyright © 2016 Urban Forrest. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    /******** VARIABLES ********/
    
    //All the buttons
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //UI design containers
    @IBOutlet weak var OuterStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    @IBOutlet weak var innerStackView4: UIStackView!
    
    //Audio-related vars
    var recordedAudio: NSURL!
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb }
    
    
    /******** OVERRIDE FUNCS ********/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setStackViewLayout()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.NotPlaying)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            
            self.setStackViewLayout()
            
            }, completion: nil)
    }
    
    
    /******** HELPER FUNCS ********/
    
    /*** UI ***/
    
    func setStackViewLayout() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        if orientation.isPortrait{
            self.OuterStackView.axis = .Vertical
            self.setInnerStackViewsAxis(.Horizontal)
        } else {
            self.OuterStackView.axis = .Horizontal
            self.setInnerStackViewsAxis(.Vertical)
        }
    }
    
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView1.axis = axisStyle
        self.innerStackView2.axis = axisStyle
        self.innerStackView3.axis = axisStyle
        self.innerStackView4.axis = axisStyle
    }
    
    /*** AUDIO ***/
    
    @IBAction func playSoundForButton(sender: UIButton) {
        //Play the sound with a playback filter
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(.Playing)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        //Stop the Audio
        stopAudio()
    }

}
