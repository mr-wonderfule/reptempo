//
//  SoundDelegate.swift
//  RepTempo
//
//  Created by Nathan Trans on 7/27/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import AVFoundation

class SoundDelegate : AVAudioPlayer, AVAudioPlayerDelegate {
    
    var filepath : NSURL? = nil;
    //var view : ViewController?;
    
    init(name : String, ofType : String){
        
        let myBundle : NSBundle = NSBundle.mainBundle();
        
        self.filepath = NSURL(fileURLWithPath: myBundle.pathForResource(name, ofType: ofType));
        
        super.init(contentsOfURL: self.filepath, error: nil);
        
        prepareToPlay();
    }
    
    override init(contentsOfURL url: NSURL!, error outError: NSErrorPointer) {
        super.init(contentsOfURL: url, error: outError);
    }
    
    override init(contentsOfURL url: NSURL!, fileTypeHint utiString: String!, error outError: NSErrorPointer) {
        super.init(contentsOfURL: url, fileTypeHint: utiString, error: outError);
    }
    
    override init(data: NSData!, error outError: NSErrorPointer) {
        super.init(data: data, error: outError);
    }
    
    override init(data: NSData!, fileTypeHint utiString: String!, error outError: NSErrorPointer) {
        super.init(data: data, fileTypeHint: utiString, error: outError);
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag {
            
        }
    }
}