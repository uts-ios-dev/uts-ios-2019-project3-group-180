//
//  HomeViewController.swift
//  LearnPiano
//
//  Created by xianyulee on 2019/5/17.
//  Copyright © 2019 Xianyu. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class HomeViewController: UIViewController {
  
    let oscillator = AKOscillatorBank()
    var att = 0.1
    var dec = 0.1
    var sus = 0.5
    var rel = 0.1

    override func viewDidLoad() {
        
        oscillator.attackDuration = att
        oscillator.decayDuration = dec
        oscillator.sustainLevel  = sus
        oscillator.releaseDuration = rel
        super.viewDidLoad()
        try? VideoBackground.shared.play(view: view, videoName: "Background", videoType: "mp4")
        
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PianoViewSegue" {
            let dest = segue.destination as! ViewController
            dest.att =  self.oscillator.attackDuration
            dest.dec =  self.oscillator.decayDuration
            dest.sus =  self.oscillator.sustainLevel 
            dest.rel =  self.oscillator.releaseDuration
        }
    }
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {
    
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
