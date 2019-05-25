//
//  SettingViewController.swift
//  LearnPiano
//
//  Created by Yizhe CHEN on 2019/5/17.
//
// Setting page to control the attackDuration
//Setting page to control the DecayDuration
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
       
        setupUI()
         let swithState = UserDefaults.standard.bool(forKey: switchSavingKey)
        modeSetting.isOn = swithState
        
    
        print(UserDefaults.standard.bool(forKey: switchSavingKey))
        //modeSetting.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        super.viewDidLoad()
    }
    /*
    @objc func stateChanged(switchState: UISwitch) {
        if modeSetting.isOn{
            modeLabel.text = "Monophonic Mode"
            polyphonicMode = false
        }else{
            modeLabel.text = "Polyphonic Mode"
            polyphonicMode = true
        }
    }
  */
    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let adsrView = AKADSRView { att, dec , sus , rel in
            
            self.oscillator.attackDuration = Double(att)
            self.oscillator.decayDuration = Double(dec)
            self.oscillator.sustainLevel = Double(sus)
            self.oscillator.releaseDuration = Double(rel)
    
            
        }
        
        stackView.addArrangedSubview(adsrView)
    
        view.addSubview(stackView)
        
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
 
    }
    
    
    @IBAction func modeSetting(_ sender: UISwitch) {
      
        if modeSetting.isOn{
             modeLabel.text = "Monophonic Mode"
             polyphonicMode = false
              UserDefaults.standard.set(sender.isOn, forKey:switchSavingKey)
            
           
        }else{
             UserDefaults.standard.set(sender.isOn, forKey:switchSavingKey)
            modeLabel.text = "Polyphonic Mode"
             polyphonicMode = true
            
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
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


