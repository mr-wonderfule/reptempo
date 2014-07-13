//
//  ViewController.swift
//  RepTempo
//
//  Created by Nathan Trans on 6/28/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var totalReps   : Int = 10;
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
    
    let optionLabels : [String] = ["0", "1", "2", "3",
                              "4", "5", "6", "7",
                              "8", "9", "10"];
    let maxReps : Int = 9999;
    let numberOfOptions : Int = 4;

    let invalidInputAlert : UIAlertView = UIAlertView(title: "Invalid number!", message: "Not a number. Please try again.", delegate: nil, cancelButtonTitle: "OKAYJOSE");
    
    @IBOutlet var totalRepField     : UITextField;
    
    @IBOutlet var timerLabel : UILabel;
    
    @IBOutlet var startButton : UIButton;
    @IBOutlet var stopButton  : UIButton;

    @IBOutlet var eccentricSegmentedControl: UISegmentedControl;
    @IBOutlet var concentricSegmentedControl: UISegmentedControl;
    
    @IBAction func setTotalReps(sender : AnyObject) {
        
        if let reps = totalRepField.text.toInt() {
            
            totalReps = reps;
        
        } else {
            
            invalidInputAlert.show();
        }
    }
    
    @IBAction func backgroundTap() {
        totalRepField.resignFirstResponder();
        view.endEditing(true);
    }
    
    @IBAction func sanitizeInput(sender: AnyObject) {
        setTotalReps(sender);
        
        if totalReps > maxReps {
            
            totalReps = maxReps;
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
                    
                    if repCounter == totalReps {
                        
                        sfxPlayer.playFinish();
                        
                        stopTimer(self);
                    }
                }
            }
        }
    }
    // Implements the  protocol
    /*func () {
    
    }*/
    
    // Implements the PickerView DataSource protocol
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        
        return numberOfOptions;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return optionLabels.count;
    }
    
    // Implements the PickerView Delegate protocol
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String {
        return optionLabels[row];
    }
    
    func pickerView(pickerView: UIPickerView!,  didSelectRow row: Int, inComponent component: Int) {
        
        switch ( component ){
            
            case 0:
                eccentric = row;
            
            case 1:
                hold = row;
            
            case 2:
                concentric = row;
            
            case 3:
                opt = row;
            
            default:
                break;
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

