//
//  StoryboardIdentifiable.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardIdentifiable {
    
    /// An identifier of view controller contained in storyboard.
    static var storyboardIdentifier: String { get }
}

// MARK: - Extension for `UIViewController` making default implementation to all view controllers which implements this protocol.

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
}
