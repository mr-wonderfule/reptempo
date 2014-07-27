//
//  ViewController.swift
//  RepTempo
//
//  Created by Nathan Trans on 6/28/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let DEBUG : Bool = true;
    
    var totalReps   : Int = 10;
    var eccentric   : Int = 1;
    var hold        : Int = 0;
    var concentric  : Int = 1;
    var opt         : Int = 0;
    
    var repCounter  : Int = 0;
    var eccCounter  : Int = 0;
    var conCounter  : Int = 0;
    
    var updateTimer : NSTimer? = nil;
    
    var timeInMilliseconds  : Float = 0.000;
    
    var stopButtonTitle : String = "Stop";
    var isPaused : Bool = false;
    
    let sfxPlayer = SoundPlayer();
    
    let interval : NSTimeInterval = 1.0;
    
    let maxReps : String = "9999";
    let numberOfOptions : Int = 4;
    let numberOfValues  : Int = 21;

    let invalidInputAlert : UIAlertView = UIAlertView(title: "Invalid input", message: "Not a number. Please try again.", delegate: nil, cancelButtonTitle: "OK");
    
    
    let bgColor = UIColor(red: CGFloat(23/255), green: CGFloat(29/255), blue: CGFloat(37/255), alpha: 1.0);
    let sectionColor = UIColor(red: CGFloat(42/255), green: CGFloat(51/255), blue: CGFloat(64/255), alpha: 1.0);
    let textColor = UIColor(red: CGFloat(195/255), green: CGFloat(215/255), blue: CGFloat(239/255), alpha: 1.0);
    let customRed = UIColor(red: CGFloat(214/255), green: CGFloat(13/255), blue: CGFloat(13/255), alpha: 1.0);
    let customGreen = UIColor(red: CGFloat(63/255), green: CGFloat(178/255), blue: CGFloat(17/255), alpha: 1.0);

    //let blurryView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark));
    
    @IBOutlet var totalRepField : UITextField;
    
    @IBOutlet var timerView : TimerView;
    @IBOutlet var pickerView : UIPickerView;
    
    @IBOutlet var eccentricSegmentedControl : UISegmentedControl;
    @IBOutlet var concentricSegmentedControl : UISegmentedControl;
    
    
    @IBOutlet var startButton : UIButton;
    @IBOutlet var stopButton  : UIButton;

    
    
    @IBAction func backgroundTap() {
        totalRepField.resignFirstResponder();
        view.endEditing(true);
    }
    
    @IBAction func sanitizeInput(sender: AnyObject) {
        setTotalReps();
    }
    
    @IBAction func startTimer(sender : AnyObject) {
        
        isPaused = false;
        pickerView.hidden = true;
        timerView.hidden = false;
        
        stopButtonTitle = "Stop";
        stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
        
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "update", userInfo: nil, repeats: true);
        
        sfxPlayer.playCountdown();
    }
    
    @IBAction func stopTimer(sender : AnyObject) {
        
        isPaused = true;
        
        pickerView.hidden = false;
        timerView.hidden = true;
        
        sfxPlayer.stopAll();
        
        switch stopButtonTitle {
            
            case "Stop":
                
                if timeInMilliseconds > 0.000 {
                    stopButtonTitle = "Reset";
                    stopButton.setTitle(stopButtonTitle, forState: UIControlState.Normal);
                }
            
            case "Reset":
                
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
    
    func setTotalReps() {
        
        if let reps = totalRepField.text.toInt() {
            
            totalReps = reps;

            let max = maxReps.toInt();
            
            if totalReps > max {
                
                totalReps = max!;
            }

            if DEBUG {
                println("setting totalReps to: \(totalReps)")
            }
            
        } else {
            
            invalidInputAlert.show();
        }
    }
    
    func update(){
        
        if !isPaused {
            
            timeInMilliseconds += Float(interval);
            
            let countdownDuration = Float(sfxPlayer.countdownPlayer.duration);
            
            if timeInMilliseconds > countdownDuration {
                
                //sfxPlayer.playBeat();
                timerView.update(atTime: timeInMilliseconds);

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
    
    
    // Implements the PickerView DataSource protocol
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        
        return numberOfOptions;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return numberOfValues;
    }
    
    
    // Implements the PickerView Delegate protocol
    func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width/4;
    }
    
    func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.height/8;
    }
    
    func pickerView(pickerView: UIPickerView!,  didSelectRow row: Int, inComponent component: Int) {
        
        if find([0,2], component) && row == 0 {
            
            self.pickerView.selectRow(1, inComponent: component, animated: true);
            
            if component == 0 {
            
                eccentric = 1;
            }
            else {
                
                concentric = 1;
            }
            return;
        }
        
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
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        
        var label = view as? UILabel;
        
        if(label == nil){
            label = UILabel(frame : CGRectMake(0, 0, pickerView.rowSizeForComponent(component).width, pickerView.rowSizeForComponent(component).height));
            
        }
        
        label!.textColor = UIColor.whiteColor();
        label!.backgroundColor = self.sectionColor;
        label!.font = UIFont(name: "HelveticaNeue-Medium", size: 18);
        label!.text = String( format: "%d", row);
        
        label!.textAlignment = .Center;
        
        return label;
    }
    
    // Implements the UITextField Delegate protocol
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    
        if (range.location + range.length) > countElements(totalRepField.text!) {
            return false;
        }
        
        let newLength = countElements(textField.text!) + countElements(string!) - range.length;
        
        return newLength <= countElements(self.maxReps);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for component in [0,2] {
            self.pickerView.selectRow(1, inComponent: component, animated: false);
        }
        
        
        
        //view.addSubview(blurryView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

