//
//  DoneTasksNavigationController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

final class DoneTasksNavigationController: UINavigationController, StoryboardIdentifiable {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    /// Setup view controller
    ///
    private func setupViewController() {
        var viewController: UIViewController!
        let doneTasksVC: DoneTasksViewController = UIStoryboard.storyboard(named: .doneTasks).instantiateViewController()
        viewController = doneTasksVC
        
        self.setViewControllers([viewController], animated: false)
    }
    
}
