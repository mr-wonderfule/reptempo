//
//  SoundPlayer.swift
//  RepTempo
//
//  Created by Nathan Trans on 6/28/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import AVFoundation

class SoundPlayer {
    
    var audioSession : AVAudioSession;
    
//    var beatURL : NSURL;
    var beatPlayer : AVAudioPlayer;
    
//    var countdownURL : NSURL;
    var countdownPlayer : AVAudioPlayer;
    
//    var finishURL : NSURL;
    var finishPlayer : AVAudioPlayer;
    
//    var signalURL : NSURL;
    var signalPlayer : AVAudioPlayer;
    
    let shortStartDelay : NSTimeInterval = 0.01;
    let filetype : String = "caf";
    let files : [String] = ["beat","countdown","finish","signal"];
    init(){
        
        self.audioSession = AVAudioSession.sharedInstance();
        self.audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil);
        self.audioSession.setActive(false, error: nil);
        
        self.beatPlayer = SoundDelegate(name: files[0], ofType: filetype);
        self.countdownPlayer = SoundDelegate(name: files[1], ofType: filetype);
        self.finishPlayer = SoundDelegate(name: files[2], ofType: filetype);
        self.signalPlayer = SoundDelegate(name: files[3], ofType: filetype);
        

//        let myBundle : NSBundle = NSBundle.mainBundle();
        
//        beatURL = NSURL(fileURLWithPath: myBundle.pathForResource("beat", ofType: "caf"));
//        beatPlayer = AVAudioPlayer(contentsOfURL: beatURL, error: nil);
//        beatPlayer.prepareToPlay();
//
//        countdownURL = NSURL(fileURLWithPath: myBundle.pathForResource("countdown", ofType: "caf"));
//        countdownPlayer = AVAudioPlayer(contentsOfURL: countdownURL, error: nil);
//        countdownPlayer.prepareToPlay();
//
//        finishURL = NSURL(fileURLWithPath: myBundle.pathForResource("finish", ofType: "caf"));
//        finishPlayer = AVAudioPlayer(contentsOfURL: finishURL, error: nil);
//        finishPlayer.prepareToPlay();
//
//        signalURL = NSURL(fileURLWithPath: myBundle.pathForResource("signal", ofType: "caf"));
//        signalPlayer = AVAudioPlayer(contentsOfURL: signalURL, error: nil);
//        signalPlayer.prepareToPlay();
        
    }
    
    func now() -> NSTimeInterval {
        return self.beatPlayer.deviceCurrentTime;
    }
    
    func playBeat(){
        self.beatPlayer.playAtTime( self.now() + self.shortStartDelay );
    }
    
    func playCountdown() {
        self.countdownPlayer.playAtTime( self.now() + self.shortStartDelay );
    }
    
    func playFinish(){
        self.finishPlayer.playAtTime( self.now() + self.shortStartDelay );
    }
    
    func playSignal() {
        self.signalPlayer.playAtTime( self.now() + self.shortStartDelay );
    }
    
    func playBeat(time : NSTimeInterval){
        self.beatPlayer.playAtTime( self.now() + time + self.shortStartDelay );
    }
    
    func playCountdown(time : NSTimeInterval) {
        self.countdownPlayer.playAtTime( self.now() + time + self.shortStartDelay );
    }
    
    func playFinish(time : NSTimeInterval){
        self.finishPlayer.playAtTime( self.now() + time + self.shortStartDelay );
    }
    
    func playSignal(time : NSTimeInterval) {
        self.signalPlayer.playAtTime( self.now() + time + self.shortStartDelay );
    }
    
    
    func stopAll(){
        /*
        beatPlayer.stop();
        countdownPlayer.stop();
        finishPlayer.stop();
        signalPlayer.stop();
        
        beatPlayer.prepareToPlay();
        countdownPlayer.prepareToPlay();
        finishPlayer.prepareToPlay();
        signalPlayer.prepareToPlay();
        */
        
        self.audioSession = AVAudioSession.sharedInstance();

        self.audioSession.setActive(false, withOptions: AVAudioSessionSetActiveOptions.OptionNotifyOthersOnDeactivation, error: nil);
    }
}