//
//  UnderlineTextField.swift
//  Happy Rings
//
//  Created by Marcin Pietrzak on 29/05/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

@IBDesignable
class UnderlineTextField: UITextField {
    
    private var placeHolderLabel = UILabel()
    private var underLineView = UIView()
    
    private (set) var placeholderMinimized = false {
        didSet {
            guard (oldValue != placeholderMinimized) else { return }
            
            let transform: CGAffineTransform!
            
            if (placeholderMinimized) {
                let k: CGFloat = 0.7
                let dx = placeHolderLabel.frame.width * (1 - k) / 2
                transform = CGAffineTransform(translationX: -dx, y: -20).scaledBy(x: k, y: k)
            } else {
                transform = .identity
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.placeHolderLabel.layer.setAffineTransform(transform)
            })
        }
    }
    
    private var isActive = false
    
    override var text: String? {
        didSet {
            updateState()
        }
    }
    
    @IBInspectable override var placeholder: String! {
        set {
            placeHolderLabel.text = newValue
            placeHolderLabel.sizeToFit()
        }
        get {
            return placeHolderLabel.text
        }
    }
    
    @IBInspectable var placeholderColor: UIColor! {
        didSet {
            placeHolderLabel.textColor = placeholderColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        clipsToBounds = false
        tintColor = textColor
        placeholderColor = .gray
        
        addSubview(placeHolderLabel)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.font = font
        addConstraint(placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor))
        addConstraint(placeHolderLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
        
        addSubview(underLineView)
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.backgroundColor = UIColor.darkGray
        var c = NSLayoutConstraint.constraints(withVisualFormat: "|[v]|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
        addConstraints(c)
        c = NSLayoutConstraint.constraints(withVisualFormat: "V:[v(2)]-(-3)-|", options: .alignAllFirstBaseline, metrics: nil, views: ["v": underLineView])
        addConstraints(c)
        
        addTarget(self, action: #selector(didStartEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func didStartEditing() {
        UIView.animate(withDuration: 0.3) {
            self.underLineView.backgroundColor = UIColor.MainColors.Blue
        }
        isActive = true
        updateState()
    }
    
    @objc func didEndEditing() {
        UIView.animate(withDuration: 0.3) {
            self.underLineView.backgroundColor = UIColor.darkGray
        }
        isActive = false
        updateState()
    }
    
    @objc func editingChanged() {
        updateState()
    }
    
    /// Update text field current state
    ///
    func updateState() {
        placeholderMinimized = isActive || !text!.isEmpty
    }
    
    /// Mark as error with vibration alert
    ///
    func markAsErrorWithVibration() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        underLineView.backgroundColor = UIColor.red
        placeholderColor = UIColor.red
        tintColor = UIColor.red
    }
    
    func markAsError() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        underLineView.backgroundColor = UIColor.red
        placeholderColor = UIColor.red
        tintColor = UIColor.red
    }
    
    /// Back to default state
    ///
    func unmarkError() {
        underLineView.backgroundColor = UIColor.MainColors.Blue
        placeholderColor = UIColor.MainColors.Blue
        tintColor = UIColor.darkGray
    }
    
}
