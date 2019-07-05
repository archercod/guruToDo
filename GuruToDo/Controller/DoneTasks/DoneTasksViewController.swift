//
//  DoneTasksViewController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

final class DoneTasksViewController: UIViewController, StoryboardIdentifiable {
    
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Setups
    
    func setupView() {
        self.title = Localized.doneTasks.string
    }
    
    // MARK: - Helpers

    
    
}
