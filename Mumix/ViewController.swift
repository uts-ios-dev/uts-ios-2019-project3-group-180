//
//  ViewController.swift
//  LearnPiano
//
//  Created by xianyulee on 2019/5/13.
//  Copyright © 2019 Xianyu. All rights reserved.
//


import AudioKit
import UIKit
import AudioKitUI
import AVFoundation

// Instruments button animation
extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 0.5, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}
class ViewController: UIViewController, AKKeyboardDelegate{
    
    @IBOutlet weak var bassBtn: UIButton!
    
    var drumTimer1 = Timer() //drum 1
    var drumTimer2 = Timer() //drum 1/2
    var drumTimer3 = Timer() //drum 1/4
    
    var snareTimer1 = Timer() //snare 1
    var snareTimer2 = Timer() //snare 1/2
    var snareTimer3 = Timer() //snare 1/4
    
    var closedTimer1 = Timer() //Closed-Hight 1
    var closedTimer2 = Timer() //Closed-Hight 1/2
    var closedTimer3 = Timer() //Closed-Hight 1/4
    
    var openTimer1 = Timer() //Opened-Hight 1
    var openTimer2 = Timer() //Opened-Hight 1/2
    var openTimer3 = Timer() //Opened-Hight 1/4
    
    
    
    let oscillator = AKOscillatorBank()
    var drumPlayer = AVAudioPlayer()
    var snarePlayer = AVAudioPlayer()
    var closedPlayer = AVAudioPlayer()
    var openPlayer = AVAudioPlayer()
    
    //Default piano settings
    var att = 0.1
    var dec = 0.1
    var sus = 0.5
    var rel = 0.1
    
    //Bitwise operation for stopping and starting at the same button
    /*
     The bitwise AND operator (&) combines the bits of two numbers. It returns a new number whose bits are set to 1 only if the bits were equal to 1 in both input numbers:*/
    
    /*The bitwise XOR operator, or “exclusive OR operator” (^), compares the bits of two numbers. The operator returns a new number whose bits are set to 1 where the input bits are different and are set to 0 where the input bits are the same*/
    let b1Bit = 1
    let b2Bit = 1 << 1
    let b3Bit = 1 << 2
    let b4Bit = 1 << 3
    let b5Bit = 1 << 4
    let b6Bit = 1 << 5
    let b7Bit = 1 << 6
    let b8Bit = 1 << 7
    let b9Bit = 1 << 8
    let b10Bit = 1 << 9
    let b11Bit = 1 << 10
    let b12Bit = 1 << 11
   
    
    var playeringFlag: Int = 0
    var polyphonicMode = false
    var isPlaying = false
    
    
    @IBOutlet weak var drum1: UIButton!  //drum 1
    @IBOutlet weak var drum2: UIButton!  //drum 1/2
    @IBOutlet weak var drum3: UIButton!  //drum 1/4
    
    @IBOutlet weak var snare3: UIButton!  //Snare 1/4
    @IBOutlet weak var snare2: UIButton!  //Snare 1/2
    @IBOutlet weak var snare1: UIButton!  //Snare 1
    
    @IBOutlet weak var closed3: UIButton! //Closed-Hight 1/4
    @IBOutlet weak var closed2: UIButton! //Closed-Hight 1/2
    @IBOutlet weak var closed1: UIButton! //Closed-Hight 1
    
    
    @IBOutlet weak var open3: UIButton! //Open-Hight 1/4
    @IBOutlet weak var open2: UIButton! //Open-Hight 1/2
    @IBOutlet weak var open1: UIButton! //Open-Hight 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //from Setting
        oscillator.attackDuration = att
        oscillator.decayDuration = dec
        oscillator.sustainLevel  = sus
        oscillator.releaseDuration = rel
        
        AudioKit.output = oscillator
        
        do {
            try AudioKit.start()
            
        } catch {
            AKLog("AudioKit did not start!")
        }
        
        
        loadKeyboard()
        
        let sound = Bundle.main.path(forResource: "kick", ofType: "wav")
        let sound2 = Bundle.main.path(forResource: "snare", ofType: "wav")
        let sound3 = Bundle.main.path(forResource: "hiHat", ofType: "wav")
        let sound4 = Bundle.main.path(forResource: "openHiHat", ofType: "wav")
        do{
            drumPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            snarePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
            closedPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound3!))
            openPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound4!))
            
            
        }catch{
            print("Error")
        }
        
    }
    
    // Hide iPhone X+ home button
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //Set up piano keyboard
    func loadKeyboard() {
        
        let keyboardView = AKKeyboardView(frame: ScreenControl.manageSize(rect: CGRect(x: 0, y:200, width: 800, height: 250)))
        keyboardView.polyphonicMode = polyphonicMode
        keyboardView.delegate = self
        
        self.view.addSubview(keyboardView)
    }
    
    func noteOn(note: MIDINoteNumber) {
        oscillator.play(noteNumber: note, velocity: 100)
    }
    
    func noteOff(note: MIDINoteNumber) {
        oscillator.stop(noteNumber: note)
    }
    
    
    @IBAction func open3(_ sender: Any) {
        playeringFlag ^= b12Bit //
       
        if  playeringFlag&b12Bit == 0{
            
            openPlayer.stop()
            self.openTimer3.invalidate()
            self.open3.blink(enabled:false)
            self.open3.backgroundColor = #colorLiteral(red: 0.2773679197, green: 0.8092252612, blue: 1, alpha: 1)
            open1.isEnabled = true
            open2.isEnabled = true
            
        }else{
            
            self.openTimer3 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer1) in
                self.openPlayer.play()
                
            })
            self.open3.backgroundColor = #colorLiteral(red: 0.09682316063, green: 0.5424412688, blue: 0.9204890286, alpha: 1)
            self.open3.blink()
            open2.isEnabled = false
            open1.isEnabled = false
        }
        
    }
    @IBAction func open2(_ sender: Any) {
        playeringFlag ^= b11Bit
       
        if  playeringFlag&b11Bit == 0{
            
            openPlayer.stop()
            self.openTimer2.invalidate()
            self.open2.blink(enabled:false)
            self.open2.backgroundColor = #colorLiteral(red: 0.2773679197, green: 0.8092252612, blue: 1, alpha: 1)
            open3.isEnabled = true
            open1.isEnabled = true
            
        }else{
            
            self.openTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer1) in
                self.openPlayer.play()
                
            })
            self.open2.backgroundColor = #colorLiteral(red: 0.09682316063, green: 0.5424412688, blue: 0.9204890286, alpha: 1)
            self.open2.blink()
            open1.isEnabled = false
            open3.isEnabled = false
        }
        
    }
    @IBAction func open1(_ sender: Any) {
        playeringFlag ^= b10Bit
       
        if  playeringFlag&b10Bit == 0{
            
            openPlayer.stop()
            self.openTimer1.invalidate()
            self.open1.blink(enabled:false)
            self.open1.backgroundColor = #colorLiteral(red: 0.2773679197, green: 0.8092252612, blue: 1, alpha: 1)
            open3.isEnabled = true
            open2.isEnabled = true
            
        }else{
            
            self.openTimer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer1) in
                self.openPlayer.play()
               
            })
            self.open1.backgroundColor = #colorLiteral(red: 0.09682316063, green: 0.5424412688, blue: 0.9204890286, alpha: 1)
            self.open1.blink()
            open2.isEnabled = false
            open3.isEnabled = false
        }
    }
    
    @IBAction func closed3(_ sender: Any) {
        playeringFlag ^= b9Bit
        
        if  playeringFlag&b9Bit == 0{
           
            closedPlayer.stop()
            self.closedTimer3.invalidate()
            self.closed3.blink(enabled:false)
            self.closed3.backgroundColor = #colorLiteral(red: 0.6836535335, green: 0.5438082814, blue: 1, alpha: 1)
            closed2.isEnabled = true
            closed1.isEnabled = true
            
        }else{
            
            self.closedTimer3 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer1) in
                self.closedPlayer.play()
                
            })
            self.closed3.backgroundColor = #colorLiteral(red: 0.5867986121, green: 0, blue: 0.9098039269, alpha: 1)
            self.closed3.blink()
            closed2.isEnabled = false
            closed1.isEnabled = false
        }
    }
    
    @IBAction func closed2(_ sender: Any) {
        playeringFlag ^= b8Bit //
       
        if  playeringFlag&b8Bit == 0{
            
            closedPlayer.stop()
            self.closedTimer2.invalidate()
            self.closed2.blink(enabled:false)
            self.closed2.backgroundColor = #colorLiteral(red: 0.6836535335, green: 0.5438082814, blue: 1, alpha: 1)
            closed1.isEnabled = true
            closed3.isEnabled = true
            
        }else{
            
            self.closedTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer1) in
                self.closedPlayer.play()
                
            })
            self.closed2.backgroundColor = #colorLiteral(red: 0.5867986121, green: 0, blue: 0.9098039269, alpha: 1)
            self.closed2.blink()
            closed1.isEnabled = false
            closed3.isEnabled = false
        }
    }
    
    @IBAction func closed1(_ sender: Any) {
        playeringFlag ^= b7Bit
     
        if  playeringFlag&b7Bit == 0{
            
            closedPlayer.stop()
            self.closedTimer1.invalidate()
            self.closed1.blink(enabled:false)
            self.closed1.backgroundColor = #colorLiteral(red: 0.6836535335, green: 0.5438082814, blue: 1, alpha: 1)
            closed2.isEnabled = true
            closed3.isEnabled = true
            
        }else{
            
            self.closedTimer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer1) in
                self.closedPlayer.play()
               
            })
            self.closed1.backgroundColor = #colorLiteral(red: 0.5867986121, green: 0, blue: 0.9098039269, alpha: 1)
            self.closed1.blink()
            closed2.isEnabled = false
            closed3.isEnabled = false
        }
        
    }
    
    @IBAction func snare3(_ sender: Any) {
        
        playeringFlag ^= b6Bit
        
        if  playeringFlag&b6Bit == 0{
            
            snarePlayer.stop()
            self.snareTimer3.invalidate()
            self.snare3.blink(enabled:false)
            self.snare3.backgroundColor = #colorLiteral(red: 1, green: 0.4952963591, blue: 0.791751802, alpha: 1)
            snare2.isEnabled = true
            snare1.isEnabled = true
            
        }else{
            
            self.snareTimer3 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer1) in
                self.snarePlayer.play()
                
            })
            self.snare3.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            self.snare3.blink()
            snare2.isEnabled = false
            snare1.isEnabled = false
        }
    }
    
    
    @IBAction func snare2(_ sender: Any) {
        playeringFlag ^= b5Bit //
        
        if  playeringFlag&b5Bit == 0{
            
            snarePlayer.stop()
            self.snareTimer2.invalidate()
            self.snare2.blink(enabled:false)
            self.snare2.backgroundColor = #colorLiteral(red: 1, green: 0.4952963591, blue: 0.791751802, alpha: 1)
            snare1.isEnabled = true
            snare3.isEnabled = true
            
        }else{
            
            self.snareTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer1) in
                self.snarePlayer.play()
               
            })
            self.snare2.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            self.snare2.blink()
            snare1.isEnabled = false
            snare3.isEnabled = false
        }
        
    }
    
    
    @IBAction func snare1(_ sender: Any) {
        playeringFlag ^= b4Bit //
        print("d3 is pressed")
        if  playeringFlag&b4Bit == 0{
            print("drum 4 is not playing")
            snarePlayer.stop()
            self.snareTimer1.invalidate()
            self.snare1.blink(enabled:false)
            self.snare1.backgroundColor = #colorLiteral(red: 1, green: 0.4952963591, blue: 0.791751802, alpha: 1)
            snare2.isEnabled = true
            snare3.isEnabled = true
            
        }else{
            
            self.snareTimer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer1) in
                self.snarePlayer.play()
                
            })
            self.snare1.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0, blue: 0.598151031, alpha: 1)
            self.snare1.blink()
            snare2.isEnabled = false
            snare3.isEnabled = false
        }
        
    }
    
    
    @IBAction func drum3(_ sender: Any) {
        
        playeringFlag ^= b3Bit
        
        if  playeringFlag&b3Bit == 0{
        
            drumPlayer.stop()
            self.drumTimer3.invalidate()
            self.drum3.blink(enabled:false)
            self.drum3.backgroundColor = #colorLiteral(red: 1, green: 0.7653519511, blue: 0.1869229376, alpha: 1)
            drum1.isEnabled = true
            drum2.isEnabled = true
            
        }else{
            
            self.drumTimer3 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer1) in
                self.drumPlayer.play()
               
            })
            self.drum3.backgroundColor = #colorLiteral(red: 1, green: 0.881786045, blue: 0, alpha: 1)
            self.drum3.blink()
            drum1.isEnabled = false
            drum2.isEnabled = false
        }
        
    }
    
    @IBAction func drum2(_ sender: Any) {
        
        playeringFlag ^= b2Bit
        
        if  playeringFlag&b2Bit == 0{
            drumPlayer.stop()
            
            self.drumTimer2.invalidate()
            self.drum2.blink(enabled:false)
            self.drum2.backgroundColor = #colorLiteral(red: 1, green: 0.7653519511, blue: 0.1869229376, alpha: 1)
            drum1.isEnabled = true
            drum3.isEnabled = true
            
        }else{
            
            self.drumTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer1) in
                self.drumPlayer.play()
                
            })
            self.drum2.backgroundColor = #colorLiteral(red: 1, green: 0.881786045, blue: 0, alpha: 1)
            self.drum2.blink()
            drum1.isEnabled = false
            drum3.isEnabled = false
        }
        
    }
    
    @IBAction func drum1(_ sender: Any) {
        
        playeringFlag ^= b1Bit
        if playeringFlag&b1Bit == 0 {
            drumPlayer.stop()
            self.drumTimer1.invalidate()
            self.drum1.blink(enabled:false)
            self.drum1.backgroundColor = #colorLiteral(red: 1, green: 0.7653519511, blue: 0.1869229376, alpha: 1)
            drum2.isEnabled = true
            drum3.isEnabled = true
            
        }else{
            
            self.drumTimer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer1) in
                self.drumPlayer.play()
            
            })
            self.drum1.backgroundColor = #colorLiteral(red: 1, green: 0.881786045, blue: 0, alpha: 1)
            self.drum1.blink()
            drum2.isEnabled = false
            drum3.isEnabled = false
            
        }
    }
    
    
    
    @IBAction func stopAll(_ sender: Any) {
        stopAll()
    }
    
    func stopAll(){
        
        drumTimer1.invalidate()
        drumTimer2.invalidate()
        drumTimer3.invalidate()
        
        snareTimer1.invalidate()
        snareTimer2.invalidate()
        snareTimer3.invalidate()
        
        closedTimer1.invalidate()
        closedTimer2.invalidate()
        closedTimer3.invalidate()
        
        openTimer1.invalidate()
        openTimer2.invalidate()
        openTimer3.invalidate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        do{
            stopAll()
            try AudioKit.stop()
            
        }catch{
            print("AudioKit doesnt stop!")
        }
        
        
    }
}

