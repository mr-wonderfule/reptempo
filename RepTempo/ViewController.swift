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
    
    var startButtonTitle: String = "Start";
    var stopButtonTitle : String = "Reset";
    var isPaused : Bool = false;
    
    let sfxPlayer = SoundPlayer();
    
    let interval : NSTimeInterval = 1.0;
    
    let maxReps : String = "9999";
    let numberOfOptions : Int = 4;
    let numberOfValues  : Int = 21;

    let invalidInputAlert : UIAlertView = UIAlertView(title: "Invalid input", message: "Not a number. Please try again.", delegate: nil, cancelButtonTitle: "OK");
    
    
    let bgColor = UIColor(red: CGFloat(23.0/255.0), green: CGFloat(29.0/255.0), blue: CGFloat(37.0/255.0), alpha: 1.0);
    let sectionColor = UIColor(red: CGFloat(42.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(64.0/255.0), alpha: 1.0);
    let textColor = UIColor(red: CGFloat(195.0/255.0), green: CGFloat(215.0/255.0), blue: CGFloat(239.0/255.0), alpha: 1.0);
    let customRed = UIColor(red: CGFloat(214.0/255.0), green: CGFloat(13.0/255.0), blue: CGFloat(13.0/255.0), alpha: 1.0);
    let customGreen = UIColor(red: CGFloat(63.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(17.0/255.0), alpha: 1.0);

    
    
    @IBOutlet var totalRepField : UITextField?;
    
    let timerView = TimerView();
    @IBOutlet var pickerView : UIPickerView?;
    
    @IBOutlet var eccentricSegmentedControl : UISegmentedControl?;
    @IBOutlet var concentricSegmentedControl : UISegmentedControl?;
    
    
    @IBOutlet var startButton : UIButton?;
    @IBOutlet var stopButton  : UIButton?;

    
    
    @IBAction func backgroundTap() {
        self.totalRepField?.resignFirstResponder();
        view.endEditing(true);
    }
    
    @IBAction func sanitizeInput(sender: AnyObject) {
        self.setTotalReps();
    }
    
    @IBAction func startTimer(sender : AnyObject) {
        
        switch self.startButtonTitle {
            
            case "Pause":
                
                self.isPaused = true;
                self.timerView.pause();
            
                self.startButtonTitle = "Resume";
                self.startButton?.setTitle(self.startButtonTitle, forState: UIControlState.Normal);
            
                self.stopButton?.setTitleColor(self.customRed, forState: UIControlState.Normal);
                self.stopButton?.enabled = self.isPaused;
            
            
            case "Resume":
                
                self.isPaused = false;
                self.timerView.resume();
            
                self.startButtonTitle = "Pause";
                self.startButton?.setTitle(self.startButtonTitle, forState: UIControlState.Normal);
            
                self.stopButton?.setTitleColor(self.sectionColor, forState: UIControlState.Normal);
                self.stopButton?.enabled = self.isPaused;

            
            case "Start":
                
                self.isPaused = false;
                self.pickerView?.hidden = true;
                self.timerView.hidden = self.isPaused;
                
                //sfxPlayer.playCountdown();
                
                self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(self.interval, target: self, selector: "update", userInfo: nil, repeats: true);
                
                
                
                self.timerView.start();
                
                self.startButton?.setTitleColor(self.textColor, forState: UIControlState.Normal);
                self.startButtonTitle = "Pause";
                self.startButton?.setTitle(self.startButtonTitle, forState: UIControlState.Normal);
            
                self.eccentricSegmentedControl?.enabled = self.isPaused;
                self.concentricSegmentedControl?.enabled = self.isPaused;
            
            default:
                break;
        }
    }
    
    @IBAction func stopTimer(sender : AnyObject) {
        
        self.isPaused = true;
        
        self.pickerView?.hidden = false;
        
        self.timerView.hidden = self.isPaused;
        self.timerView.reset();
        
        self.updateTimer!.invalidate();
        self.updateTimer = nil;
        
        self.sfxPlayer.stopAll();
        
        self.timeInMilliseconds = 0.000;
                
        self.repCounter = 0;
        self.eccCounter = 0;
        self.conCounter = 0;
        
        self.stopButton?.setTitle(self.stopButtonTitle, forState: UIControlState.Normal);
        self.stopButton?.setTitleColor(self.sectionColor, forState: UIControlState.Normal);
        self.stopButton?.enabled = false;

        self.startButton?.setTitleColor(self.customGreen, forState: UIControlState.Normal);
        self.startButtonTitle = "Start";
        self.startButton?.setTitle(self.startButtonTitle, forState: UIControlState.Normal);

        self.eccentricSegmentedControl?.enabled = self.isPaused;
        self.concentricSegmentedControl?.enabled = self.isPaused;
    }
    
    func setTotalReps() {
        
        if let reps = self.totalRepField?.text.toInt() {
            
            self.totalReps = reps;

            let max = self.maxReps.toInt();
            
            if self.totalReps > max {
                
                self.totalReps = max!;
            }
            
        } else {
            
            self.invalidInputAlert.show();
        }
    }
    
    func setTotalTime(totalTime: CFTimeInterval) {
        self.timerView.setDuration(totalTime);
    }
    
    func toggleSegmentedControlFromKey(key: String) {
        
        if key == "ecc" {
            
            let oppositeIndex = (self.eccentricSegmentedControl?.selectedSegmentIndex == 0) ? 1 : 0;
            self.concentricSegmentedControl?.setEnabled(true, forSegmentAtIndex: oppositeIndex);
            
        }
        else {
        
            let oppositeIndex = (self.concentricSegmentedControl?.selectedSegmentIndex == 0) ? 1 : 0;
            self.concentricSegmentedControl?.setEnabled(true, forSegmentAtIndex: oppositeIndex);
        }
    }
    
    func update() {
        
        if !isPaused {
            
            self.timeInMilliseconds += Float(self.interval);
            
            let countdownDuration = Float(self.sfxPlayer.countdownPlayer.duration);
            
            if self.timeInMilliseconds > countdownDuration {
                
                //sfxPlayer.playBeat();

                self.eccCounter++;
                self.conCounter++;
            

                let totalEccentricTime  = self.eccentric + self.hold + Int(countdownDuration);
                let totalConcentricTime = self.concentric + self.opt + Int(countdownDuration);
                
                let eccFlag = self.eccCounter == totalEccentricTime;
                let conFlag = self.conCounter == totalConcentricTime;

                if eccFlag || conFlag {
                    
                    self.sfxPlayer.playSignal();
                    
                    self.eccCounter = (eccFlag ? 0 : self.eccCounter);
                    self.conCounter = (conFlag ? 0 : self.conCounter);
                    
                    if conFlag {
                    
                        self.repCounter++;
                    }
                    
                    //repCounter = (conFlag ? repCounter+1 : repCounter);
                    
                    if self.repCounter == self.totalReps {
                        
                        self.sfxPlayer.playFinish();
                        
                        self.stopTimer(self);
                    }
                }
            }
        }
    }
    
    
    // Implements the PickerView DataSource protocol
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        
        return self.numberOfOptions;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return self.numberOfValues;
    }
    
    
    // Implements the PickerView Delegate protocol
    func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width/4;
    }
    
    func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.height/8;
    }
    
    func pickerView(pickerView: UIPickerView!,  didSelectRow row: Int, inComponent component: Int) {
        
        // Eccentric and concentric seconds should not be 0
        if find([0,2], component) != nil && row == 0 {
            
            self.pickerView?.selectRow(1, inComponent: component, animated: true);
            
            if component == 0 {
            
                self.eccentric = 1;
            }
            else {
                
                self.concentric = 1;
            }
        }
        else {
            
            switch ( component ){
            
                case 0:
                    self.eccentric = row;
            
                case 1:
                    self.hold = row;
            
                case 2:
                    self.concentric = row;
            
                case 3:
                    self.opt = row;
            
                default:
                    break;
            }
        }
        
        let currentTotalTime = CFTimeInterval((self.eccentric + self.hold + self.concentric + self.opt) * self.totalReps) + self.sfxPlayer.countdownPlayer.duration;
        
        self.setTotalTime(currentTotalTime);
    }
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        
        var label = view as? UILabel;
        
        if(label == nil){
            label = UILabel(frame : CGRectMake(0, 0, pickerView.rowSizeForComponent(component).width, pickerView.rowSizeForComponent(component).height));
            
        }
        
        label!.textColor = UIColor.whiteColor();
        label!.backgroundColor = self.bgColor;
        label!.font = UIFont(name: "HelveticaNeue-Medium", size: 18);
        label!.text = String( format: "%d", row);
        
        label!.textAlignment = .Center;
        
        return label;
    }
    
    // Implements the UITextField Delegate protocol
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    
        if (range.location + range.length) > self.totalRepField?.text?.utf16Count {
            return false;
        }
        
        let newLength = countElements(textField.text!) + countElements(string!) - range.length;
        
        return newLength <= countElements(self.maxReps);
    }
    
    // Default? Yeah, I'm good.
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Eccentric and concentric seconds should not be 0
        for component in [0,2] {
            self.pickerView?.selectRow(1, inComponent: component, animated: false);
        }
        
        self.setTotalTime(2.0);
        
        self.stopButton?.setTitle(self.stopButtonTitle, forState: UIControlState.Normal);
        self.stopButton?.setTitleColor(self.sectionColor, forState: UIControlState.Normal);
        self.stopButton?.setTitleShadowColor(self.bgColor, forState: UIControlState.Normal);
        self.stopButton?.enabled = false;
        
        self.startButton?.setTitleShadowColor(self.bgColor, forState: UIControlState.Normal);
                
        
        self.view.addSubview(timerView);
        
        
        self.eccentricSegmentedControl?.addTarget(self, action: "toggleSegmentedControlFromKey(\"ecc\"", forControlEvents: UIControlEvents.ValueChanged);
        
        self.concentricSegmentedControl?.addTarget(self, action: "toggleSegmentedControlFromKey(\"con\"", forControlEvents: UIControlEvents.ValueChanged);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

