//
//  HelpViewController.swift
//  LearnPiano
//
//  Created by Christian Nguyen on 25/5/19.
//  Copyright © 2019 Xianyu. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var pianoHelpLabel: UILabel!
    @IBOutlet weak var settingsHelpLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        pianoHelpLabel.lineBreakMode = .byWordWrapping
        pianoHelpLabel.numberOfLines = 0
        pianoHelpLabel.text = "Press the keys at the bottom of the screen to play notes.\n\nPress the pads at the top to enable drum loops.\n1/4 - plays 4 times in a given moment.\n1/2 - plays 2 times in a given moment.\n1 - plays 1 time in a given moment.\n\nPress record begin recording and press again to end recording.\nPress play to play the recording.\nPress delete to delete the recording."
        
        settingsHelpLabel.lineBreakMode = .byWordWrapping
        settingsHelpLabel.numberOfLines = 0
        settingsHelpLabel.text = "Monophonic - Play one note at a time.\nPolyphonic - Play multiple notes at a time.\n\nSlide the colours to tweak the piano output, the line represents how the sound's volume changes over time.\nAttack - the time taken to reach from nil to peak.\nDecay - The the of the run down from the attack to sustain.\nSustain - the volume you hear when holding the key.\nRelease - The time taken for the volume to drop to 0 after releasing the key."
        // Do any additional setup after loading the view.
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
