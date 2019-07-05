//
//  ActiveTasksViewController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class ActiveTasksViewController: UIViewController, StoryboardIdentifiable {
    
    // MARK: - Enums
    
    enum CellIdentifier: String {
        case activeTaskCell = "ActiveTaskCell"
    }
    
    // MARK: - Properties
    
    let context = CoreDataManager.getManagedContext()
    
    var activeTasks = [Task]()
    
    let coverView = UIView()
    
    var addTaskViewIsHidden: Bool = true
    var isInEditTaskMode: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    @IBOutlet fileprivate(set) weak var addAndEditTaskView: AddAndEditTaskView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadAcviteTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Setups
    
    /// Setup view
    ///
    private func setupView() {
        self.title = Localized.activeTasks.string
        
        self.addAndEditTaskView.alpha = 0
        self.addAndEditTaskView.delegate = self
    }
    
    /// Setup table view
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = TableViewRow.height.rawValue
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction private func addTaskButtonDidTapped(_ sender: UIBarButtonItem) {
        if addTaskViewIsHidden {
            self.showAddAndEditTaskView {
                self.addAndEditTaskView.alpha = 1
                self.addTaskViewIsHidden = false
            }
        } else {
            self.hideAddAndEditTaskView {
                self.coverView.removeFromSuperview()
                self.addTaskViewIsHidden = true
            }
        }
    }
    
    /// Show alert with message
    ///
    /// - Parameter message: String
    func showAlertWith(message: String) {
        let alert = UIAlertController(title: Localized.success.string, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func accessoryButtonTapped(sender : UIButton) {
        sender.setImage(UIImage(named: "doneTaskButton"), for: .normal)
        
        let activeTask = activeTasks[sender.tag]
        activeTask.isActive = false
        CoreDataManager.saveContext()
        
        self.loadAcviteTasks()
        self.tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    /// Load active tasks from core data
    ///
    private func loadAcviteTasks() {
        activeTasks = fetchLocalData(active: true)
    }
    
    /// Save data
    ///
    private func saveData() {
        CoreDataManager.saveContext()
        self.loadAcviteTasks()
        tableView.reloadData()
        self.showAlertWith(message: Localized.taskIsDone.string)
    }
    
    /// Save task
    ///
    /// - Parameter completion: @escaping () -> Void
    private func saveTask(completion: @escaping () -> Void) {
        let task = Task(context: context)
        task.name = addAndEditTaskView.taskTextField.text!
        task.isActive = true
        CoreDataManager.saveContext()
        completion()
    }
    
    // MARK: - Add task popup
    
    /// Show category filters view
    ///
    /// - Parameter completion: @escaping () -> Void
    private func showAddAndEditTaskView(completion: @escaping () -> Void) {
        self.setupBgCoverView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCoverView))
        coverView.addGestureRecognizer(tap)
        self.view.insertSubview(coverView, belowSubview: addAndEditTaskView)
        
        UIView.animate(withDuration: 0.5) {
            self.addAndEditTaskView.isHidden = false
            self.addAndEditTaskView.alpha = 1
            self.view.layoutIfNeeded()
            completion()
        }
    }
    
    /// Hide category filter view
    ///
    /// - Parameter completion: @escaping () -> Void
    private func hideAddAndEditTaskView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) {
            self.addAndEditTaskView.alpha = 0
            self.addAndEditTaskView.isHidden = true
            self.coverView.removeFromSuperview()
            self.view.layoutIfNeeded()
            completion()
        }
    }
    
    /// Setup background cover view when popup is visible
    ///
    func setupBgCoverView() {
        let window = UIWindow()
        coverView.frame = window.frame
        coverView.isUserInteractionEnabled = true
        coverView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    }
    
    /// Handle tap cover view
    ///
    @objc func handleTapCoverView() {
        self.hideAddAndEditTaskView {}
    }
    
    // MARK: - Fetch data
    
    /// Fetch local data from core data with choosen state
    ///
    /// - Parameter active: Bool
    /// - Returns: [Task]
    func fetchLocalData(active: Bool) -> [Task] {
        do {
            let formatRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: "isActive == %@", NSNumber(value: active))
            formatRequest.predicate = predicate
            let fetchResults = try context.fetch(formatRequest)
            return fetchResults
        } catch {
            fatalError(Localized.loadingDataError.string)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ActiveTasksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.activeTaskCell.rawValue, for: indexPath)
        
        guard let activeTask = activeTasks[indexPath.row].name else { return UITableViewCell() }
        
        cell.textLabel?.text = activeTask
        cell.textLabel?.numberOfLines = 0
        
        let checkMarkButton = UIButton(type: .custom)
        checkMarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkMarkButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
        checkMarkButton.layer.borderWidth = 1.0
        checkMarkButton.layer.borderColor = UIColor.blue.cgColor
        checkMarkButton.layer.masksToBounds = true
        checkMarkButton.contentMode = .scaleAspectFit
        checkMarkButton.tag = indexPath.row
        
        cell.accessoryView = checkMarkButton as UIView
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ActiveTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let activeTask: Task
            activeTask = activeTasks[indexPath.row]
            context.delete(activeTask)
            CoreDataManager.saveContext()
            loadAcviteTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                self.isInEditTaskMode = true
                let activeTask = self.activeTasks[indexPath.row]
                self.showAddAndEditTaskView {
                    self.addAndEditTaskView.taskTextField.text = activeTask.name
                    
                    self.isInEditTaskMode = false
                }
            }
        }
    }
    
}

// MARK: - AddAndEditTaskViewDelegate

extension ActiveTasksViewController: AddAndEditTaskViewDelegate {
    
    func doneButtonDidTapped(_ sender: UIButton) {
        self.saveTask {
            self.hideAddAndEditTaskView {
                self.addAndEditTaskView.taskTextField.text = ""
                self.loadAcviteTasks()
                self.tableView.reloadData()
            }
        }
    }
    
}
