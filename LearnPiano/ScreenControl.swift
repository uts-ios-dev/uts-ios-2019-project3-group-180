//
//  ScreenControl.swift
//  LearnPiano
//
//  Created by xianyulee on 2019/5/13.
//  Copyright © 2019 Xianyu. All rights reserved.
//

import UIKit

class ScreenControl {
    
    static let screenWidthRatio = UIScreen.main.bounds.width / 736
    static let screenHeightRatio = UIScreen.main.bounds.height / 414
    
    static func manageSize(rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x * screenWidthRatio, y: rect.origin.y * screenHeightRatio, width: rect.width * screenWidthRatio, height: rect.height * screenHeightRatio)
        
    }
    
    
}

