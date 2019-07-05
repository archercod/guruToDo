//
//  XibIdentifiable.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

/// A type which can be identified for XIB file.
///
/// - Important: Should be used on objects which inherits from `UIView`.
protocol XIBIdentifiable {
    
    /// Name of XIB file for type.
    static var XIBName: String { get }
}

// MARK: - Extension for `UIView` making default implementation to all views which implements this protocol.
extension XIBIdentifiable where Self: UIView {
    
    static var XIBName: String {
        return String(describing: self)
    }
}
