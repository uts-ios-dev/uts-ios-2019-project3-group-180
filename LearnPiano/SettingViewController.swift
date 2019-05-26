//
//  SettingViewController.swift
//  LearnPiano
//
//  Created by Yizhe CHEN on 2019/5/17.
//

import AudioKit
import UIKit
import AudioKitUI

class SettingViewController: UIViewController {
    
    var polyphonicMode = false
    let oscillator = AKOscillatorBank()
    var transportView: CAInterAppAudioTransportView?
    let switchSavingKey = "switchSavingKey"
    
    @IBOutlet weak var modeSetting: UISwitch!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    override func viewDidLoad() {
        
        
        AudioKit.output = oscillator
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        //Audiobus.start()
        loadSwitchSetting()
        setupUI()
        super.viewDidLoad()
    }
    
    // Save switch setting
    func loadSwitchSetting(){
        let switchState = UserDefaults.standard.bool(forKey: switchSavingKey)
        modeSetting.isOn = switchState
    }
    
    // Set up setting view
    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Import from AudioKit framework
        let adsrView = AKADSRView { att, dec , sus , rel in
            
            self.oscillator.attackDuration = Double(att)
            self.oscillator.decayDuration = Double(dec)
            self.oscillator.sustainLevel = Double(sus)
            self.oscillator.releaseDuration = Double(rel)
            
            
        }
        
        stackView.addArrangedSubview(adsrView)
        
        view.addSubview(stackView)
        
        //Contraints
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    //Change piano mode
    @IBAction func modeSetting(_ sender: UISwitch) {
        
        if modeSetting.isOn{
            modeLabel.text = "Monophonic Mode"
            polyphonicMode = false
            //save setting
            UserDefaults.standard.set(sender.isOn, forKey:switchSavingKey)
            
            
        }else{
            //save setting
            UserDefaults.standard.set(sender.isOn, forKey:switchSavingKey)
            modeLabel.text = "Polyphonic Mode"
            polyphonicMode = true
            
        }
    }
    
    //Hide iPhone X+ home button
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //Pass data to HomeviewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "HomeViewSegue" {
            
            do {
                try AudioKit.stop()
            } catch {
                AKLog("AudioKit did not stop!")
            }
            let dest = segue.destination as! HomeViewController
            dest.att =  self.oscillator.attackDuration
            dest.dec =  self.oscillator.decayDuration
            dest.sus =  self.oscillator.sustainLevel
            dest.rel =  self.oscillator.releaseDuration
            dest.polyphonicMode = polyphonicMode 
            
        }
        
        
        
    }
}


