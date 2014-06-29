//
//  ViewController.swift
//  RepTempo
//
//  Created by Nathan Trans on 6/28/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var totalRepField     : UITextField;
    @IBOutlet var eccentricField    : UITextField;
    @IBOutlet var holdField         : UITextField;
    @IBOutlet var concentricField   : UITextField;
    @IBOutlet var optField          : UITextField;
    
    @IBOutlet var timerLabel : UILabel;
    
    @IBOutlet var startButton : UIButton;
    @IBOutlet var stopButton  : UIButton;
    
    var totalRep    : Int? = 0;
    var eccentric   : Int? = 0;
    var hold        : Int? = 0;
    var concentric  : Int? = 0;
    var opt         : Int? = 0;
    
    var repCounter  : Int = 0;
    var eccCounter  : Int = 0;
    var conCounter  : Int = 0;
    
    var updateTimer : NSTimer? = nil;
    var beatTimer   : NSTimer? = nil;
    
    var timeInMilliseconds  : Float = 0.000;
    var timeInSeconds       : Int = 0;
    
    var stopButtonTitle : String = "Stop";
    var isPaused : Bool = false;
    
    let sfxPlayer = SoundPlayer();
    
    @IBAction func backgroundTap() {
        view.endEditing(true);
    }
    
    @IBAction func processTotalRep(sender : AnyObject) {
        totalRep = totalRepField.text.toInt();
    }
    
    @IBAction func processEccentric(sender : AnyObject) {
        eccentric = eccentricField.text.toInt();
    }
    
    @IBAction func processHold(sender : AnyObject) {
        hold = holdField.text.toInt();
    }
    
    @IBAction func processConcentric(sender : AnyObject) {
        concentric = concentricField.text.toInt();
    }
    
    @IBAction func processOptHold(sender : AnyObject) {
        opt = optField.text.toInt();
    }
    
    
    
    @IBAction func startTimer(sender : AnyObject) {
        
        isPaused = false;
        
        stopButtonTitle = "Stop";
        stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
        
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "updateTimerLabel", userInfo: nil, repeats: true);
        
        beatTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateBeatTimer", userInfo: nil, repeats: true);
        
        sfxPlayer.playCountdown();
        
    }
    
    @IBAction func stopTimer(sender : AnyObject) {
        
        isPaused = true;
        
        sfxPlayer.stopAll();
        
        switch stopButtonTitle {
            
            case "Stop":
                
                if timeInMilliseconds > 0.000 {
                    stopButtonTitle = "Reset";
                    stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
                }
            
            case "Reset":
                
                timerLabel.text = "0.000";
                timeInMilliseconds = 0.000;
                
                timeInSeconds = 0;
                repCounter = 0;
                eccCounter = 0;
                conCounter = 0;
                
                stopButtonTitle = "Stop";
                stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
            
                updateTimer!.invalidate();
                updateTimer = nil;
            
                beatTimer!.invalidate();
                beatTimer = nil;
            
            default:
                break;
        }
    }
    
    func updateBeatTimer(){
        
        if !isPaused {
            
            timeInSeconds++;
            eccCounter++;
            conCounter++;
            
            let countdownDuration = Int(sfxPlayer.countdownPlayer.duration);
            
            if timeInSeconds >= countdownDuration {
                
                sfxPlayer.playBeat();
                
                let totalEccentricTime  = eccentric! + hold! + countdownDuration;
                let totalConcentricTime = concentric! + opt! + countdownDuration;
                
                if eccCounter == totalEccentricTime ||
                   conCounter == totalConcentricTime
                {
                    
                    sfxPlayer.playSignal();
                    
                    repCounter = (conCounter == totalConcentricTime ? repCounter+1 : repCounter);
                    
                    if repCounter == totalRep {
                        
                        
                    }
                }
            }
        }
    }
    
    func updateTimerLabel(){
        
        if !isPaused {
            
            timeInMilliseconds += 0.001;
            timerLabel.text = String(format: "%.3f", timeInMilliseconds);
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

