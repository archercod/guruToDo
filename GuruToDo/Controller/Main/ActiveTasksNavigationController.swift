//
//  ActiveTasksNavigationController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

final class ActiveTasksNavigationController: UINavigationController, StoryboardIdentifiable {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        
        self.navigationController?.title = Localized.active.string
    }
    
    /// Setup view controller
    ///
    private func setupViewController() {
        var viewController: UIViewController!
        let activeTasksVC: ActiveTasksViewController = UIStoryboard.storyboard(named: .activeTasks).instantiateViewController()
        viewController = activeTasksVC
        
        self.setViewControllers([viewController], animated: false)
    }
    
}
