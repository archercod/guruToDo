//
//  DoneTasksViewController.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class DoneTasksViewController: UIViewController, StoryboardIdentifiable {
    
    // MARK: - Enums
    
    enum CellIdentifier: String {
        case doneTaskCell = "DoneTaskCell"
    }
    
    // MARK: - Properties
    
    let context = CoreDataManager.getManagedContext()
    
    var doneTasks = [Task]()
    
    // MARK: - Outlets
    
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadDoneTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Setups
    
    /// Setup View
    ///
    private func setupView() {
        self.title = Localized.doneTasks.string
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
    
    @objc func accessoryButtonTapped(sender : UIButton) {
        sender.setImage(nil, for: .normal)
        
        let doneTask = doneTasks[sender.tag]
        doneTask.isActive = true
        CoreDataManager.saveContext()
        
        self.loadDoneTasks()
        self.tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    /// Load done tasks
    ///
    private func loadDoneTasks() {
        doneTasks = fetchLocalData(active: false)
    }
    
    // MARK: - Fetch data
    
    /// Fetch local data with choosen state
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

extension DoneTasksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if !doneTasks.isEmpty {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = Localized.emptyDoneTasksMessage.string
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.doneTaskCell.rawValue, for: indexPath)
        
        guard let doneTask = doneTasks[indexPath.row].name else { return UITableViewCell() }
        
        cell.textLabel?.text = doneTask
        cell.textLabel?.numberOfLines = 0
        
        let checkMarkButton = UIButton(type: .custom)
        checkMarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkMarkButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
        checkMarkButton.layer.borderWidth = 1.0
        checkMarkButton.layer.borderColor = UIColor.MainColors.Blue.cgColor
        checkMarkButton.setImage(UIImage(named: "doneTaskButton"), for: .normal)
        checkMarkButton.layer.masksToBounds = true
        checkMarkButton.contentMode = .scaleAspectFit
        checkMarkButton.tag = indexPath.row
        
        cell.accessoryView = checkMarkButton as UIView
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension DoneTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let doneTask: Task
            doneTask = doneTasks[indexPath.row]
            context.delete(doneTask)
            CoreDataManager.saveContext()
            loadDoneTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
    }
    
}
