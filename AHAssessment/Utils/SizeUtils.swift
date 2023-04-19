//
//  SizeUtils.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class SizeConstants {
    
    // Screen width.
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // Center X
    static var centerX: CGFloat {
        return screenWidth / 2
    }
    
    // Center Y
    static var centerY: CGFloat {
        return screenHeight / 2
    }
    
    static var startJourneyButtonWidth: CGFloat = 150.0
    
    static var preferredButtonHeight: CGFloat = 54.0
    static var preferredButtonCornerRadius = 5.0
}
