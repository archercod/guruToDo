//
//  AddAndEditTaskView.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

protocol AddAndEditTaskViewDelegate {
    func doneButtonDidTapped(_ sender: UIButton)
}

class AddAndEditTaskView: UIView, XIBCreatable {
    
    // MARK: - Properties
    
    var delegate: AddAndEditTaskViewDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet fileprivate(set) weak var backgroundView: UIView!
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate(set) weak var taskTextField: UnderlineTextField!
    @IBOutlet fileprivate(set) weak var doneButton: UIButton!
    
    // MARK: - Initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.createFromXIB()
        
        self.setupView()
    }
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        backgroundView.layer.cornerRadius = 24
        backgroundView.clipsToBounds = true
        
        titleLabel.text = Localized.addNewTask.string
        
        doneButton.setTitle(Localized.done.string, for: .normal)
        doneButton.layer.cornerRadius = 20
        doneButton.clipsToBounds = true
    }
    
    // MARK: - Actions
    
    @IBAction private func doneButtonDidTapped(_ sender: UIButton) {
        delegate?.doneButtonDidTapped(sender)
    }
    
}
