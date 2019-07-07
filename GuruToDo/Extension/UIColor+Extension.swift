//
//  UIColor+Extension.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 07/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Convenience initializers
    
    /// Initializes and returns color object from hex string.
    ///
    /// - Parameter hex: A hex formatted string (ex. #ff0000 means red color).
    convenience init(hex: String) {
        assert(hex.first == "#", "Wrong hex format. You forgot about prefix '#'.")
        assert(hex.count == 7, "Wrong hex format. Use format like: #000000.")
        
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        
        // omits char '#'
        scanner.scanLocation = 1
        scanner.scanHexInt32(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    struct MainColors {
        static var Blue: UIColor { get { return UIColor(hex: "#4582F4") } }
    }
    
}
