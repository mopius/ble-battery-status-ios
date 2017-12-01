//
//  Mopius+String.swift
//
//  Created by Patrick Steiner on 17.11.15.
//  Copyright © 2015 Mopius. All rights reserved.
//

import UIKit

extension String {
    
    /**
     Generate a UIColor from a hex color string
     */
    var hexColor: UIColor? {

        let hex = self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let a, r, g, b: UInt32

        var int = UInt32()

        guard Scanner(string: hex).scanHexInt32(&int) else { return nil }

        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}
