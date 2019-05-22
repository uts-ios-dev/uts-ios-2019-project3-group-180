//
//  SettingViewController.swift
//  LearnPiano
//
//  Created by xianyulee on 2019/5/17.
//  Copyright © 2019 Xianyu. All rights reserved.
//

import AudioKit
import UIKit
import AudioKitUI

class SettingViewController: UIViewController {
    
    let oscillator = AKOscillatorBank()
    var transportView: CAInterAppAudioTransportView?

    override func viewDidLoad() {
        
        
        AudioKit.output = oscillator
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        //Audiobus.start()
        
        setupUI()
        super.viewDidLoad()
    }
  
    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let adsrView = AKADSRView { att, dec, sus, rel in
            self.oscillator.attackDuration = att
            self.oscillator.decayDuration = dec
            self.oscillator.sustainLevel = sus
            self.oscillator.releaseDuration = rel
        }
        
        stackView.addArrangedSubview(adsrView)
    
        view.addSubview(stackView)
        
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
 
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
            
        }
       
  
    
}
}


