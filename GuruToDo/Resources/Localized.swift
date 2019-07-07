//
//  Localized.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation

public enum Localized {
    
    // MARK: Universal
    
    case active
    case activeTasks
    case addNewTask
    case done
    case doneTasks
    case editTask
    case errorEmptyTextFieldMessage
    case loadingDataError
    case success
    case taskIsDone
    case taskIsActive

    public var string: String {
        get {
            switch self {
            case .active:
                return NSLocalizedString("Active", comment: "")
            case .activeTasks:
                return NSLocalizedString("Active tasks", comment: "")
            case .addNewTask:
                return NSLocalizedString("Add new task", comment: "")
            case .done:
                return NSLocalizedString("Done", comment: "")
            case .doneTasks:
                return NSLocalizedString("Done tasks", comment: "")
            case .editTask:
                return NSLocalizedString("Edit task", comment: "")
            case .errorEmptyTextFieldMessage:
                return NSLocalizedString("Please fill the task name", comment: "")
            case .loadingDataError:
                return NSLocalizedString("Loading data error", comment: "")
            case .success:
                return NSLocalizedString("Success", comment: "")
            case .taskIsDone:
                return NSLocalizedString("You marked task as done", comment: "")
            case .taskIsActive:
                return NSLocalizedString("You marked task as active", comment: "")
            }
        }
    }
    
}
