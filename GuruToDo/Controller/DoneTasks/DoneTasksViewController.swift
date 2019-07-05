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
        
        self.loadAcviteTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        self.title = Localized.doneTasks.string
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = TableViewRow.height.rawValue
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    func showAlertWith(message: String) {
        let alert = UIAlertController(title: Localized.success.string, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func accessoryButtonTapped(sender : UIButton) {
        sender.setImage(nil, for: .normal)
        
        let doneTask = doneTasks[sender.tag]
        doneTask.isActive = true
        CoreDataManager.saveContext()
        
        self.loadAcviteTasks()
        self.tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func loadAcviteTasks() {
        doneTasks = fetchLocalData(active: false)
    }
    
    // MARK: - Fetch data
    
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
        return 1
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
        checkMarkButton.layer.borderColor = UIColor.blue.cgColor
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
            loadAcviteTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadData()
    }
    
}
