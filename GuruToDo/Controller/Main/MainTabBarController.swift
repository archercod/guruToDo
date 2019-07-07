//
//  MainTabBarController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit

final class MainTabBarController: MMTabBarAnimateController, StoryboardIdentifiable {
    
    // MARK: - Enums
    
    enum TabItem: Int {
        case active = 0
        case done
    }
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setAnimate(index: 0, animate: .icon(type: .scale(rate: 1.2)))
        super.setAnimate(index: 1, animate: .icon(type: .scale(rate: 1.2)))
        
        self.setTabs()
        self.addShadow()
    }
    
    deinit {
        print("\(type(of: self)) deinited.")
    }
    
    // MARK: - Helper
    
    private func getViewController<T: UIViewController>(for tabItem: TabItem) -> T? {
        return (self.viewControllers?[tabItem.rawValue] as? UINavigationController)?.viewControllers.first as? T
    }
    
    // MARK: - Setups
    
    /// Set tabs
    ///
    private func setTabs() {
        self.tabBar.items?[TabItem.active.rawValue].title = Localized.activeTasks.string
        self.tabBar.items?[TabItem.done.rawValue].title = Localized.doneTasks.string
        
        self.tabBar.items?[TabItem.active.rawValue].image = UIImage(named: "activeTasksIcon")
        self.tabBar.items?[TabItem.active.rawValue].selectedImage = UIImage(named: "activeTasksIcon")
        
        self.tabBar.items?[TabItem.done.rawValue].image = UIImage(named: "doneTasksIcon")
        self.tabBar.items?[TabItem.done.rawValue].selectedImage = UIImage(named: "doneTasksIcon")
    }
    
    /// Add shadow to tab bar
    ///
    private func addShadow() {
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.75
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 4
    }
    
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
}
