//
//  UIStoryboard+Extension.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    // MARK: - Enums
    
    enum Storyboard: String {
        case main = "Main"
        case activeTasks = "ActiveTasks"
        case doneTasks = "DoneTasks"
    }
    
    // MARK: - Helpers
    
    /// Returns defined `UIStoryboard`.
    ///
    /// - Parameters:
    ///   - storyboard: A declared storyboard.
    ///   - bundle: A bundle which contains provided storyboard. `nil` by default.
    /// - Returns: A `UIStoryboard`.
    class func storyboard(named storyboard: Storyboard, from bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    /// Returns a `UIViewController` with specific class contained in storyboard.
    ///
    /// - Returns: `UIViewController` from storyboard.
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard let viewController = optionalViewController as? T  else {
            fatalError("A `UIViewController` with specified class not exist.")
        }
        
        return viewController
    }
    
}
