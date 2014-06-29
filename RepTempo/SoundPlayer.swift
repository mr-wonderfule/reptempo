//
//  SoundPlayer.swift
//  RepTempo
//
//  Created by Nathan Trans on 6/28/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    
    var audioSession : AVAudioSession;
    
    var beatURL : NSURL;
    var beatPlayer : AVAudioPlayer;
    
    var countdownURL : NSURL;
    var countdownPlayer : AVAudioPlayer;
    
    var finishURL : NSURL;
    var finishPlayer : AVAudioPlayer;
    
    var signalURL : NSURL;
    var signalPlayer : AVAudioPlayer;
    
    init(){
        
        audioSession = AVAudioSession.sharedInstance();
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil);
        audioSession.setActive(false, error: nil);

        let myBundle : NSBundle = NSBundle.mainBundle();
        
        beatURL = NSURL(fileURLWithPath: myBundle.pathForResource("beat", ofType: "caf"));
        beatPlayer = AVAudioPlayer(contentsOfURL: beatURL, error: nil);
        beatPlayer.prepareToPlay();
        
        countdownURL = NSURL(fileURLWithPath: myBundle.pathForResource("countdown", ofType: "caf"));
        countdownPlayer = AVAudioPlayer(contentsOfURL: countdownURL, error: nil);
        countdownPlayer.prepareToPlay();

        finishURL = NSURL(fileURLWithPath: myBundle.pathForResource("finish", ofType: "caf"));
        finishPlayer = AVAudioPlayer(contentsOfURL: finishURL, error: nil);
        finishPlayer.prepareToPlay();

        signalURL = NSURL(fileURLWithPath: myBundle.pathForResource("signal", ofType: "caf"));
        signalPlayer = AVAudioPlayer(contentsOfURL: signalURL, error: nil);
        signalPlayer.prepareToPlay();

        
        
    }
    
    func playBeat(){
        beatPlayer.play();
    }
    
    func playCountdown() {
        countdownPlayer.play();
    }
    
    func playFinish(){
        finishPlayer.play();
    }
    
    func playSignal() {
        signalPlayer.play();
    }
    
    func stopAll(){
        beatPlayer.stop();
        countdownPlayer.stop();
        finishPlayer.stop();
        signalPlayer.stop();
        
        beatPlayer.prepareToPlay();
        countdownPlayer.prepareToPlay();
        finishPlayer.prepareToPlay();
        signalPlayer.prepareToPlay();
        
        audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, withFlags: AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation, error: nil);
    }
}