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
    
    var totalRep    : Int = 0;
    var eccentric   : Int = 0;
    var hold        : Int = 0;
    var concentric  : Int = 0;
    var opt         : Int = 0;
    
    var repCounter  : Int = 0;
    var eccCounter  : Int = 0;
    var conCounter  : Int = 0;
    
    var updateTimer : NSTimer? = nil;
    
    var timeInMilliseconds  : Float = 0.000;
    
    var stopButtonTitle : String = "Stop";
    var isPaused : Bool = false;
    
    let sfxPlayer = SoundPlayer();
    
    let interval : NSTimeInterval = 0.016667;
    
    @IBAction func backgroundTap() {
        view.endEditing(true);
    }
    
    @IBAction func processTotalRep(sender : AnyObject) {
        
        if let res = totalRepField.text.toInt() {
            
            totalRep = res;
        
        } else {
        
            totalRep = 0;
            totalRepField.text = String(totalRep);
        }
    }
    
    @IBAction func processEccentric(sender : AnyObject) {
        
        if let res = eccentricField.text.toInt() {
        
            eccentric = res;
        
        } else {
        
            eccentric = 0;
            eccentricField.text = String(eccentric);
        }
    }
    
    @IBAction func processHold(sender : AnyObject) {
        
        if let res = holdField.text.toInt() {
            
            hold = res;
            
        } else {
        
            hold = 0;
            holdField.text = String(hold);
        }
    }
    
    @IBAction func processConcentric(sender : AnyObject) {
        
        if let res = concentricField.text.toInt() {
            
            concentric = res;
            
        } else {
        
            concentric = 0;
            concentricField.text = String(concentric);
        }
    }
    
    @IBAction func processOptHold(sender : AnyObject) {
        
        if let res = optField.text.toInt() {
            
            opt = res;
            
        } else {
            
            opt = 0;
            optField.text = String(opt);
        }
    }
    
    
    
    @IBAction func startTimer(sender : AnyObject) {
        
        isPaused = false;
        
        stopButtonTitle = "Stop";
        stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
        
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "update", userInfo: nil, repeats: true);
        
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
                
                repCounter = 0;
                eccCounter = 0;
                conCounter = 0;
                
                stopButtonTitle = "Stop";
                stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
            
                updateTimer!.invalidate();
                updateTimer = nil;
            
            
            default:
                break;
        }
    }
    
    func update(){
        
        if !isPaused {
            
            timeInMilliseconds += Float(interval);
            timerLabel.text = String(format: "%.3f", timeInMilliseconds);

            let countdownDuration = Float(sfxPlayer.countdownPlayer.duration);
            
            if timeInMilliseconds > countdownDuration {
                
                sfxPlayer.playBeat();
                
                eccCounter++;
                conCounter++;
            

                let totalEccentricTime  = eccentric + hold + Int(countdownDuration);
                let totalConcentricTime = concentric + opt + Int(countdownDuration);
                
                let eccFlag = eccCounter % totalEccentricTime == 0;
                let conFlag = conCounter % totalConcentricTime == 0;

                if eccFlag || conFlag {
                    
                    sfxPlayer.playSignal();
                    
                    repCounter = (conFlag ? repCounter+1 : repCounter);
                    
                    if repCounter == totalRep {
                        
                        sfxPlayer.playFinish();
                        
                        stopTimer(self);
                    }
                }
            }
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

