//
//  XibCreatable.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

/// A type which can be created from XIB file.
///
/// - Important: Should be used on objects which inherits from `UIView`.
protocol XIBCreatable: XIBIdentifiable {
    
    /// Creates a view from XIB file with options.
    /// For more info, check (loadNibNamed:owner:options:)[https://developer.apple.com/reference/foundation/nsbundle/1618147-loadnibnamed?language=objc]
    ///
    /// - Parameters:
    ///   - specificXibClass: A specific XIB file for given class.
    ///   - options: An options.
    func createFromXIB(specificXibClass: AnyClass?, options: [AnyHashable: Any]?)
}

// MARK: - Extension for `UIView` making default implementation to all views which implements this protocol.
extension XIBCreatable where Self: UIView {
    
    func createFromXIB(specificXibClass: AnyClass? = nil, options: [AnyHashable: Any]? = nil) {
        let xibClass: AnyClass = specificXibClass ?? type(of: self)
        let xibClassName = String(describing: xibClass)
        guard let view = Bundle(for: xibClass).loadNibNamed(xibClassName, owner: self, options: options as? [UINib.OptionsKey: Any])?.first as? UIView else {
            fatalError("A XIB for class `\(String(describing: Self.self))` not exist.")
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
}
